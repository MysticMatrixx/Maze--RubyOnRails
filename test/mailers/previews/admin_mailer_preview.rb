# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/csv_user_created
  def csv_user_created
    AdminMailer.with(user: User.first, file: 'user.csv').csv_user_created
  end

end
