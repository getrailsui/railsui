class ApplicationMailer < ActionMailer::Base
  helper Railsui::MailHelper

  default from: email_address_with_name("#{Railsui.config.support_email}", "#{Railsui.config.application_name}")
  layout "mailer"
end
