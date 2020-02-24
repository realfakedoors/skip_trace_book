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
    next if homie.confirmed_friends?(pal) || pal.confirmed_friends?(homie)
    homie.send_friend_request(pal)
    friendship = Friendship.find_by(user: homie, friend: pal)
    pal.accept_friend_request(friendship)
  end
end

# Groups
User.all.each do |user|
  5.times do
    group_name  = Faker::Company.unique.name
    description = Faker::Company.buzzword
    objective   = Faker::Company.catch_phrase
    
    user.groups.create!(name: user.name, description: description[0, 90], objective: objective)
  end
end

# Memberships
Group.all.each do |group|
  User.all.sample(10).each do |member|
    Membership.create!(user: member, group: group, confirmed: true)
  end
end

# Pages
User.all.each do |user|
  5.times do
      page_name = Faker::Restaurant.name
    description = Faker::TvShows::BojackHorseman.tongue_twister
       location = Faker::Address.community
        website = Faker::Internet.unique.url
        mission = Faker::Restaurant.description
        
    user.pages.create!(name: page_name, 
                description: description[0, 90], 
                   location: location,
                    website: website,
                    mission: mission[0, 450] )
  end
end

# Followings
Page.all.each do |page|
  User.all.sample(10).each do |follower|
    Following.create!(user: follower, page: page)
  end
end