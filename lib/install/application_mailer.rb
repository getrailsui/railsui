class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("#{Railsui.config.support_email}", "#{Railsui.config.application_name}")

  # Required to use helpers in mailers
  helper ApplicationHelper

  layout "mailer"
end
