require 'faker'

Faker::Config.locale = :fr

Comment.destroy_all
Post.destroy_all
User.destroy_all

User.create!(nickname: "Romain", email: "romain@mail.com", password: "123456")

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

5.times do
  Post.create!(
    user: User.all.sample,
    title: Faker::Lorem.sentence,
    content: Faker::Lorem.paragraph,
    url: Faker::Internet.url
  )
end

puts "seeded #{Post.count} posts"

50.times do
  Comment.create!(
    user: User.all.sample,
    post: Post.all.sample,
    content: Faker::Lorem.sentence
  )
end

puts "seeded #{Comment.count} comments"
