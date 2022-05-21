class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.csv_user_created.subject

  def csv_user_created
    @user = params[:user]
    @file = params[:file]

    # @greeting = "Hi"
    attachments['maze.svg'] = File.read('app/assets/images/maze_logo.svg')

    mail(
      from: 'MADMIN <admin@maze.com>',
      to: email_address_with_name(@user.email, @user.first_name),
      subject: 'USERS CREATED FROM CSV/XLSX'
    )
  end
end
