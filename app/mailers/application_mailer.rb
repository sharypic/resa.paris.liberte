class ApplicationMailer < ActionMailer::Base
  include CalendarsHelper
  helper_method :add_to_google_calendar_url,
                :download_reservation_ics_url

  default from: ENV['MAIL_FROM']
  layout 'mailer'
end
