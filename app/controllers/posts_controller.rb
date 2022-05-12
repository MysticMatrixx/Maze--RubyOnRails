class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[show edit update destroy]

  # before_action :is_public?, only: [:status]

  def index

    # if current_user.has_role? :admin
    #   redirect_to
    # else
    @user = User.all if current_user.has_role? :admin
    @posts = Post.all.order(id: :desc)
    # end
  end

  def edit; end

  def show
    @comments = @post.comments
  end

  def create
    @post = Post.new(post_params)

    # @status = @post.status.public?

    @post.user_id = current_user.id
    # render plain: @post
    respond_to do |format|
      if @post.save
        format.html { redirect_back(fallback_location: post_url(@post), notice: 'Post was successfully created!') }
        # format.json { render :show, status: :created, location: @post }
      else
        format.html { render :index, status: :unprocessable_entity }
        # format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated!' }
        # format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        # format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post was successfully deleted!' }
      # format.json { head :no_content }
    end
  end

  private

  # def is_public?
  #   unless VALID_STATUSES.display?
  #     redirect_to :back
  #   end
  # end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :status)
  end
end
