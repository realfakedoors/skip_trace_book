class StaticPagesController < ApplicationController
  
  skip_before_action :authenticate_user!
  
  def home
    if user_signed_in?
      @post       = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    else
      @tour_items = [["Groups",             "https://i.imgur.com/NljW4Oa.png"],
                     ["Friendships",        "https://i.imgur.com/9xGZV75.png"],
                     ["Direct Messages",    "https://i.imgur.com/hPyePy0.png"],
                     ["Likes and Comments", "https://i.imgur.com/hmM18XN.png"],
                     ["Photos and Albums",  "https://i.imgur.com/Kr2m7NL.png"],
                     ["Official Pages",     "https://i.imgur.com/3hJyUiw.png"]]
      @top_row    = @tour_items.first(3)
      @bottom_row = @tour_items.last(3)
    end
  end
  
  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
