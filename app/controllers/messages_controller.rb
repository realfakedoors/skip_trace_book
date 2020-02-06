class MessagesController < ApplicationController
  before_action :set_message,  only: [:destroy]
  before_action :correct_user, only: [:destroy]
  
  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if @message.save
      redirect_back fallback_location: root_url
    else
      redirect_to root_url, notice: "Unable to send message!"
    end      
  end

  def destroy
    @message.destroy
    flash[:success] = "Message deleted."
    redirect_back fallback_location: root_url
  end
  
  private
  
    def message_params
      params.require(:message).permit(:content,
                                        :photo,
                               :messageable_id,
                             :messageable_type,
               photo_attributes: [:photo_data])
    end
    
    def set_message
      @message = Message.find(params[:id])
    end
    
    def able_to_access_message?(user)
      attached       = @message.messageable
      attached_class = @message.messageable_type
      case attached_class
        when "Discussion"
          true if attached.group.confirmed_members.include?(user)
        when "DirectMessage"
          true if attached.recipient == user || attached.initiator == user
      end
    end
    
    def correct_user
      unless able_to_access_message?(current_user)
        redirect_to root_url, notice: "You can't view that photo!"
      end
    end
    
end
