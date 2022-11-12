module Railsui
  module MailHelper
    def spacer(amount = 16)
      render "railsui/shared/email_spacer", amount: amount
    end

    def email_action(action, url, options={})
      align = options[:align] ||= "left"
      theme = options[:theme] ||= "primary"
      path = options[:path] ||= "#"
      fullwidth = options[:fullwidth] ||= false
      render "railsui/shared/email_action", align: align, theme: theme, action: action, path: path, fullwidth: fullwidth
    end

    def email_callout(&block)
      render "railsui/shared/email_callout", block: block
    end
  end
end
