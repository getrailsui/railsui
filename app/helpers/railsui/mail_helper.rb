module Railsui
  module MailHelper
    def spacer(amount = 16)
      render "railsui/shared/email_spacer", amount: amount
    end

    def mail_action(action, url, options={})
      align = options[:align] ||= "center"
      theme = options[:theme] ||= "primary"
      path = options[:path] ||= "#"
      render "railsui/shared/email_action", align: align, theme: theme, action: action, path: path
    end
  end
end
