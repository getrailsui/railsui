module Railsui
  module MailHelper
    def spacer(amount = 16)
      render "rui/shared/email_spacer", amount: amount
    end

    def email_action(action, url, options={})
      align = options[:align] ||= "left"
      theme = options[:theme] ||= "primary"
      fullwidth = options[:fullwidth] ||= false
      render "rui/shared/email_action", align: align, theme: theme, action: action, url: url, fullwidth: fullwidth
    end

    def email_callout(&block)
      render "rui/shared/email_callout", block: block
    end
  end
end
