require 'test_helper'

class DeviseMailerTest < ActionMailer::TestCase
  fixtures :residents

  test '.confirmation_instructions works' do
    email = DeviseMailer.confirmation_instructions(residents(:mfo), 'token')
    byebug
    assert_equal [ENV['MAIL_FROM']], email.from, 'wrong from address'
  end

  test '.reset_password_instructions works' do
    email = DeviseMailer.reset_password_instructions(residents(:mfo), 'token')
    assert_equal [ENV['MAIL_FROM']], email.from, 'wrong from address'
  end
end
