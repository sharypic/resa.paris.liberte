require 'default_mailer_from'

class ApplicationMailer < ActionMailer::Base
  include CalendarsHelper

  helper_method :add_to_google_calendar_url,
                :download_reservation_ics_url  

  default from: DefaultMailerFrom.formatted_email
  layout 'mailer'
end
