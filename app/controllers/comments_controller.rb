class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id
    @comment.save

    # redirect_to :session["#{scope}_return_to"]
    # redirect_to root_path
    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
      @comment.destroy
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
