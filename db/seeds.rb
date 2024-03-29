require 'faker'
require "open-uri"
require "nokogiri"

Faker::Config.locale = :fr

Comment.destroy_all
Post.destroy_all
User.destroy_all

admin = User.create!(nickname: "bonnebouffe.shop", email: "admin@mail.com", password: "123456")

10.times do
  nickname = Faker::Name.first_name
  email = "#{nickname.unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(/\s+/, "")}@mail.com"
  User.create!(
    nickname: nickname,
    email: email,
    password: "123456"
  )
end

puts "seeded #{User.count} users"

ingredient = "beef"
url = "https://www.bbcgoodfood.com/search?q=#{ingredient}"
html_file = URI.open(url).read
html_doc = Nokogiri::HTML.parse(html_file)
html_doc.search(".layout-md-rail__primary .card").each do |element|
  title = element.at_css(".card__content a").text.strip
  recipe_url = "https://www.bbcgoodfood.com"+element.at_css(".card__content a").attribute("href").value
  content = element.at_css(".card__content p").inner_html
  photo_url = element.at_css(".image__img").attribute("src").value
  Post.create!(
    user: admin,
    title: title,
    url: recipe_url,
    content: content,
    photo: photo_url
  )
end

puts "seeded #{Post.count} posts"

25.times do
  Comment.create!(
    user: User.all.sample,
    post: Post.all.sample,
    content: Faker::Lorem.sentence
  )
end

puts "seeded #{Comment.count} comments"
