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

# Friendships
universal_homies = User.all.sample(25)
universal_homies.each do |homie|
  User.all.each do |pal|
    homie.send_friend_request(pal)
    friendship = Friendship.find_by(user: homie, friend: pal)
    pal.accept_friend_request(friendship)
  end
end