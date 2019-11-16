class StaticPagesController < ApplicationController
  
  skip_before_action :authenticate_user!
  
  def home
    if user_signed_in?
      @post       = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
  end
  
  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
