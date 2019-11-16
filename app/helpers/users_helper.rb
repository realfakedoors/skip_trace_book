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
  
end
