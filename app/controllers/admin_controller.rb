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

  # def perform(csv_file_key, _current_user)
  #
  #   accessible_attributes = %w[first_name last_name id password email phone]
  #   # role = %w[role]
  #   CSV.open(csv_file_key, headers: true) do |row|
  #     user = User.find_by_id(row['id']) || User.new
  #     user.attributes = row.to_hash.slice(*accessible_attributes)
  #     user.skip_confirmation!
  #     user.save!
  #     user.add_role :user
  #     # user.add_role(row.to_hash.slice[*role])
  #   end
  # end
  #
  # def import_page; end

  def import_users
    # binding.pry
    # path = File.open params[:file_csv]
    skip = true

    # UPDATING USER IS NOT FUNCTIONING,
    # ONLY UPLOADING WORKS!
    CSV.foreach(params[:file_csv].path, headers: false) do |row|
      unless skip
        accessible_attributes = %w[first_name last_name password email phone]
        # FixParamsWorker.perform_async(row)
        # user = find_by_id(row['id']) || new
        # user.attributes = row.to_hash.slice(*accessible_attributes)
        hash = Hash[accessible_attributes.zip(row)]
        ImportFileWorker.perform_async(hash)
      end
      skip = false
    end
    AdminMailer.with(user: current_user, file: params[:file_csv].original_filename).csv_user_created.deliver_later
    # User.import(params[:file_csv])
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
    @user.skip_confirmation!
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

  def create_blob
    file_name = params[:file_csv]
    file = File.open(file_name)
    result = ActiveStorage::Blob.service
    # result = ActiveStorage::Blob.create_and_upload! io: file,
    #                                                 filename: file_name.original_filename
    key = 'unique_key'
    result.upload(key, file)
    result.download(key)
    # result.delete(key)
    file.close
  end

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
