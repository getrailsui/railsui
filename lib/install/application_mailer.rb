class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("from@#{Railsui.config.application_name.parameterize(separator: "")}.com", "#{Railsui.config.application_name}")
  layout "mailer"
end
