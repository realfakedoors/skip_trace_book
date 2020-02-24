class PhotosController < ApplicationController
  before_action :set_photo,        except: [:new, :create]
  before_action :photo_accessible, except: [:new, :create]
  
  def new
    @photo = Photo.new
  end

  def show
    @comments = @photo.comments.paginate(page: params[:page], per_page: 10)
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_back fallback_location: @photo, notice: "Photo was successfully created!"
    else
      redirect_to root_url, notice: "Unable to save photo!"
    end
  end
  
  def edit
  end
  
  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: 'photo updated!'
    else
      render :edit, notice: 'Failed to update photo!'
    end
  end

  def destroy
    @photo.destroy
    redirect_back fallback_location: root_url, notice: 'Photo was successfully destroyed.'
  end
  
  def photo_modal
  end

  private

    def photo_params
      params.require(:photo).permit(:photo_data, 
                                         :title, 
                                   :description, 
                           :photo_attachable_id, 
                         :photo_attachable_type)
    end
    
    def set_photo
      @photo = Photo.find(params[:id])
    end
    
    def able_to_access_photo?(user)
      attached =       @photo.photo_attachable
      attached_class = @photo.photo_attachable_type
      case attached_class
        when "Album"
          true if attached.user.confirmed_friends?(user) || attached.user == current_user
        when "Page"
          true if attached.followers.include?(current_user) || attached.admin == current_user
        when "Group"
          true if attached.confirmed_members.include?(current_user) || attached.leader == current_user
        when "Message"
          if attached.messageable_type    == "DirectMessage"
            true if attached.messageable.recipient == current_user || attached.messageable.initiator == current_user
          elsif attached.messageable_type == "Discussion"
            true if attached.messageable.group.confirmed_members.include?(current_user)
          end
      end
    end
    
    def photo_accessible
      unless able_to_access_photo?(current_user)
        redirect_to root_url, notice: "You can't view that photo!"
      end
    end
end
