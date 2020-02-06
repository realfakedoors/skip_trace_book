class GroupsController < ApplicationController
  before_action :set_group,  except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy, :unconfirmed_members]

  def index
    @groups = Group.all.paginate(page: params[:page], per_page: 20)
  end

  def show
    @discussions = @group.discussions
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      @group.members << @group.leader
      @group.confirm(@group.leader)
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new, notice: "Unable to create group!"
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end
  
  def members
    @confirmed_members = @group.confirmed_members.paginate(page: params[:page], per_page: 9)
  end
  
  def unconfirmed_members
    @unconfirmed_members = @group.unconfirmed_members.paginate(page: params[:page], per_page: 9)
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end
    
    def correct_user
      unless current_user == @group.leader
        redirect_to root_url, notice: "You're not the leader of this group."
      end
    end

    def group_params
      params.require(:group).permit(:user_id, :name, :description, :objective, :avatar)
    end
end
