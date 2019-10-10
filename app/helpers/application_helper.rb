module ApplicationHelper
  
  # Generates a page's full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "SkipTraceBook"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  # Renders the items on the bottom of a user's card display.  
  def card_footer_items(user)
    if user == current_user
      ["My Profile", "My Posts"]
    else
      ["Profile", "Friend Request", "Message"]
    end      
  end
  
end
