require 'test_helper'

class MessageTest < ActionMailer::TestCase
  test "tickets" do
    mail = Message.tickets
    assert_equal "Tickets", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
