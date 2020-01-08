class PagesController < ApplicationController
  before_action :set_page,     except: [:index, :new,    :create ]
  before_action :correct_user,   only: [:edit,  :update, :destroy]

  def index
    @pages = Page.all
  end

  def show
  end

  def new
    @page = Page.new
  end

  def edit
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new
    end
  end
  
  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end
    
    def correct_user
      unless current_user == @page.admin
        redirect_to root_url, notice: "You're not the administrator of this page."
      end
    end

    def page_params
      params.require(:page).permit(:name, :description, :location, :website, :mission, :user_id)
    end
end
