class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :destroy]
  before_action :correct_user,   only: [:show, :destroy]
  
  def new
    @discussion = Discussion.new
    @discussion.messages.build.build_photo
  end
  
  def create
    @discussion = Discussion.new(discussion_params)
    
    if @discussion.save
      redirect_to @discussion
    else
      redirect_to root_url, notice: "Unable to create discussion!"
    end
  end

  def show
    @messages = @discussion.messages.paginate(page: params[:page], per_page: 10)
    
    @message = Message.new
  end

  def destroy
    @discussion.destroy
    flash[:success] = "Discussion deleted."
    redirect_back fallback_location: root_url
  end
  
  private
  
    def able_to_access_discussion?(user)
      true if @discussion.group.confirmed_members.include?(user)
    end
    
    def correct_user
      unless able_to_access_discussion?(current_user)
        redirect_to root_url, notice: "You can't view this discussion because you're not a confirmed member of this group!"
      end
    end
  
    def discussion_params
      params.require(:discussion).permit(:group_id, 
                                            :title, 
                               messages_attributes: [:user_id,
                                                     :content,
                                                     :messageable_type,
                                                     :messageable_id,
                                  photo_attributes: [:photo_data,
                                                     :photo_attachable_type,
                                                     :photo_attachable_id ]])
    end
    
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end
end
