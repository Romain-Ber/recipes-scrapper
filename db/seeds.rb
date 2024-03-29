require 'faker'
require "open-uri"
require "nokogiri"

Faker::Config.locale = :fr

Comment.destroy_all
Post.destroy_all
User.destroy_all

admin = User.create!(nickname: "bonnebouffe.shop", email: "admin@mail.com", password: "123456")

50.times do
  nickname = Faker::Name.first_name
  email = "#{nickname.unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(/\s+/, "")}@mail.com"
  if User.all.any? { |user| user.email == email }
    email += "#{rand(1..90000)}"
  end
  User.create!(
    nickname: nickname,
    email: email,
    password: "123456"
  )
end

puts "seeded #{User.count} users"

COMMENTS = [
  "Ah mais c'est INCROYABLE!",
  "POURQUOI JE N'AI PAS CONNU CETTE RECETTE AVANT?",
  "c'est vraiment délicieux, merci!",
  "Vive la bonne bouffe!",
  "Extra!",
  "TOP!",
  "Super recette",
  "J'ai adoré, merci pour le partage!",
  "Je vais essayer ça ce soir, merci!",
  "Je n'ai pas aimé, je ne recommande pas.",
  "bof.",
  "Vraiment pas top",
  "TROP BONNNNN!!!!",
  "woaw, super recette, merci!",
  "Je recommande à 100%",
  "Enfin une recette simple et rapide, merci!"
]

ingredient = "beef"
url = "https://www.bbcgoodfood.com/search?q=#{ingredient}"
html_file = URI.open(url).read
html_doc = Nokogiri::HTML.parse(html_file)
html_doc.search(".layout-md-rail__primary .card").each do |element|
  title = element.at_css(".card__content a").text.strip
  recipe_url = "https://www.bbcgoodfood.com"+element.at_css(".card__content a").attribute("href").value
  content = element.at_css(".card__content p").inner_html
  photo_url = element.at_css(".image__img").attribute("src").value
  post = Post.create!(
    user: admin,
    title: title,
    url: recipe_url,
    content: content,
    photo: photo_url
  )
  3.times do
    Comment.create!(
    user: User.all.sample,
    post: post,
    content: COMMENTS.sample
  )
  end
end

puts "seeded #{Post.count} posts"

puts "seeded #{Comment.count} comments"
