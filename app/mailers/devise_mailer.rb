# Custom mailer for devise in order to support MJML layouts
# see: https://github.com/plataformatec/devise/wiki/How-To:-Use-custom-mailer
# see: https://github.com/plataformatec/devise/blob/master/app/mailers/devise/mailer.rb
class DeviseMailer < Devise::Mailer   
  include Devise::Controllers::UrlHelpers 
  
  helper :application 
  default template_path: 'devise/mailer'
  layout 'mailer'

  # override mail method of devise
  # see: https://github.com/plataformatec/devise/blob/master/lib/devise/mailers/helpers.rb
  def devise_mail(record, action, opts = {}, &block)
    initialize_from_record(record)
    mail(headers_for(action, opts)) do |format|
      format.mjml
      format.text
    end
  end

  #
  # Explicitely show integrated mails
  #
  def confirmation_instructions(record, token, opts = {})
    super
  end

  def reset_password_instructions(record, token, opts = {})
    super
  end
end
  
