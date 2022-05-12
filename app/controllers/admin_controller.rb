class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?

  before_action :set_user, only: %i[edit update destroy]

  def manage
    @users = User.all
  end

  def report
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.name_posts_comments_likes, filename: "All_users_report_#{Date.today}.csv" }
      format.xlsx { send_data @users.name_posts_comments_likes, filename: "All_users_report_#{Date.today}.xlsx" }
    end
  end

  def new; end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user.add_role params[:role]
        format.html { redirect_to admin_manager_menu_path, notice: 'User created successfully' }
        # format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_back(fallback_location: admin_new_user_path, alert: 'Fields are not filled properly.') }
      end
    end
  end

  def edit; end

  def update
    if @user.update(kam_ka_params)
      redirect_to admin_manager_menu_path, notice: 'User successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_manager_menu_path, notice: 'User Deleted!'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def kam_ka_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email)
  end

  def user_params
    params.permit(:first_name, :last_name, :phone, :email, :password)
  end

  def is_admin?
    redirect_to root_path unless current_user.has_role? :admin
  end
end
