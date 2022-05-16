class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @user = User.all if current_user.has_role? :admin
    @posts = Post.all.order(id: :desc)
  end

  def edit; end

  def show
    @comments = @post.comments
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_back(fallback_location: post_url(@post), notice: 'Post was successfully created!')
    else
      redirect_to posts_path, alert: @post.errors.full_messages.to_sentence
    end
  end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: 'Post was successfully updated!'
    else
      redirect_to edit_post_path(@post), alert: @post.errors.full_messages.to_sentence
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted!'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :status)
  end
end
