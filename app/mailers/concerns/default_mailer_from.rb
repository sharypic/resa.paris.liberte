require 'mail'
# used by application mailer & devise.rb for default email
module DefaultMailerFrom
  def self.formatted_email
    address = Mail::Address.new ENV['MAIL_FROM'] 
    address.display_name = ENV['MAIL_DISPLAY_NAME'] 
    address.format
  end
end
