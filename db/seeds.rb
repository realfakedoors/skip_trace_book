# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
100.times do 
  name = Faker::Name.unique.name
  user = User.create!(
    name: name,
    email: Faker::Internet.email(name: name),
    password: "password"
    )
  user.skip_confirmation_notification!
  user.confirm
end

# Posts
User.all.each do |user|
  50.times do
    content = Faker::Hipster.sentence(random_words_to_add: 10)
    user.posts.create!(content: content)
  end
end

