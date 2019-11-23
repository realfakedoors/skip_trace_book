module UsersHelper
  
  # Renders the items on the bottom of a user's card display.  
  def card_footer_items(user)
    friends =  link_to "Friends", friends_user_path(user)
    if user == current_user
      ["My Posts", friends]
    else
      ["Message", friends]
    end      
  end
  
  # Renders a user's profile info on their show page.
  def profile_info_items(user)
    occupation = ["Occupation", user.occupation]
    company =    ["Company",    user.company]
    location =   ["Location",   user.location]
    birthday =   ["Birthday",   user.birthday? ? user.birthday.strftime("%m/%d/%Y") : nil]
    [ occupation, company, location, birthday ]
  end
  
end
