class DirectMessagesController < ApplicationController
  before_action :set_direct_message, only: [:show, :destroy]
  before_action :correct_user,       only: [:show, :destroy]
  
  def new
    @direct_message = DirectMessage.new
    @direct_message.messages.build.build_photo
    
    @friends = []
    accepted_friendships = current_user.friendships.where(accepted: true)
    if accepted_friendships.any?
      @friends = accepted_friendships.map{|f| f.friend}
    end
  end
  
  def create
    @direct_message = DirectMessage.new(direct_message_params)
    
    if @direct_message.save
      redirect_to @direct_message
    else
      redirect_to new_direct_message_url, notice: "Unable to send Direct Message!"
    end
  end

  def show
    @messages = @direct_message.messages.paginate(page: params[:page], per_page: 10)
    
    @message = Message.new
  end

  def index
    u = current_user
       user_messages = DirectMessage.where(initiator: u).or(DirectMessage.where(recipient: u))
     sorted_messages = user_messages.sort_by{|dm| dm.messages.last.created_at}.reverse!
    @direct_messages = sorted_messages.paginate(page: params[:page], per_page: 15)
  end

  def destroy
    @direct_message.destroy
    flash[:success] = "Direct Message deleted."
    redirect_back fallback_location: root_url
  end
  
  private
  
    def set_direct_message
      @direct_message = DirectMessage.find(params[:id])
    end
  
    def correct_user
      unless @direct_message.initiator == current_user || @direct_message.recipient == current_user
        redirect_to root_url, notice: "You're not able to view other people's direct messages!"
      end
    end
  
    def direct_message_params
      params.require(:direct_message).permit(:initiator_id, 
                                             :recipient_id, 
                                       messages_attributes: [:user_id,
                                                             :content,
                                                             :messageable_type,
                                                             :messageable_id,
                                          photo_attributes: [:photo_data,
                                                             :photo_attachable_type,
                                                             :photo_attachable_id ]])
    end
end
