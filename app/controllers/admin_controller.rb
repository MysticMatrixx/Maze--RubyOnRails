class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?

  before_action :set_user, only: %i[edit update destroy change_password update_password]

  def manage
    @users = User.all
  end

  # controllers are not nessecary to create
  # if the view is created with its routes
  # it works just fine until we need something more to do with like interaction with models

  # def report; end


  # def import_page; end

  def import_users
    csv_file = File.open(params[:file])
    ImportUsersJob.perform_now(csv_file, current_user)
    redirect_to admin_manager_menu_path, notice: 'CSV/Excel Imported!'
  end

  # def change_password; end

  def update_password
    if @user.update(password_params)
      redirect_to admin_manager_menu_path, notice: 'User password successfully updated!'
    else
      redirect_back(fallback_location: :change_password, alert: @user.errors.full_messages.to_sentence)
    end
  end

  def all_pcl_report
    @users = User.all
    respond_to do |format|
      format.html
      format.csv do
        send_data @users.name_posts_comments_likes,
                  filename: "All_users_report_#{Date.today}_#{Time.now.to_formatted_s(:time)}.csv"
      end
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename = \"All_users_report_#{Date.today}_#{Time.now.to_formatted_s(:time)}.xlsx\""
      end
    end
  end

  def tenp_report
    @users = User.all
    respond_to do |format|
      format.html
      format.csv do
        send_data @users.up10_name_posts_comments_likes,
                  filename: "User_more_than_10_posts_report_#{Date.today}_#{Time.now.to_formatted_s(:time)}.csv"
      end
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename = \"User_more_than_10_posts_report_#{Date.today}_#{Time.now.to_formatted_s(:time)}.xlsx\""
      end
    end
  end

  def postwise_report
    @posts = Post.all
    respond_to do |format|
      format.html
      format.csv do
        send_data @posts.description_comments_likes,
                  filename: "All_posts_report_#{Date.today}_#{Time.now.to_formatted_s(:time)}.csv"
      end
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename = \"All_posts_report_#{Date.today}_#{Time.now.to_formatted_s(:time)}.xlsx\""
      end
    end
  end

  # def new; end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        @user.add_role params[:role]
        format.html { redirect_to admin_manager_menu_path, notice: 'User created successfully' }
        # format.json { render :show, status: :created, location: @post }
      else
        format.html { redirect_back(fallback_location: admin_new_user_path, alert: @user.errors.full_messages.to_sentence) }
      end
    end
  end

  # def edit; end

  def update
    if @user.update(kam_ka_params)
      redirect_to admin_manager_menu_path, notice: 'User successfully updated!'
    else
      render :edit, alert: @user.errors.full_messages.to_sentence
    end
  end

  def destroy
    @user.destroy!
    redirect_to admin_manager_menu_path, notice: 'User Deleted!'
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

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
