class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_back fallback_location: root_url
    else
      redirect_to root_url, notice: "You can't comment on that!"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back fallback_location: root_url
  end
  
  private
  
    def comment_params
      params.require(:comment).permit(:commentable_id, :commentable_type, :content)
    end
end
