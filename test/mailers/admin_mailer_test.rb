require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "csv_user_created" do
    mail = AdminMailer.csv_user_created
    assert_equal "Csv user created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
