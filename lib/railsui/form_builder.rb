require "action_view"

module Railsui
  class FormBuilder < ActionView::Helpers::FormBuilder
    delegate :content_tag, :tag, :safe_join, :capture, to: :@template

    def text_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def email_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def password_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def number_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def telephone_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end
    alias phone_field telephone_field

    def url_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def date_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def datetime_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def time_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def color_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input-color")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def search_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-input")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def text_area(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-textarea")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def select(method, choices = nil, options = {}, html_options = {})
      field_wrapper(method, html_options) do
        add_default_class!(html_options, "form-select")
        add_error_class!(html_options) if has_error?(method)
        super(method, choices, options, html_options)
      end
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      wrapper_options = options.delete(:wrapper) || {}
      label_text = options.delete(:label)
      label_class = options.delete(:label_class) || "form-label"
      is_required = options.delete(:required) || false

      # Set default flex layout for the wrapper
      wrapper_class = "flex items-center justify-start gap-2"
      wrapper_options[:class] = [wrapper_class, wrapper_options[:class]].compact.join(" ")

      content_tag(:div, wrapper_options) do
        add_default_class!(options, "form-input-checkbox")
        add_error_class!(options) if has_error?(method)

        if label_text
          check_box_html = super(method, options, checked_value, unchecked_value)
          label_options = { class: label_class }
          label_options[:required] = true if is_required
          label_html = label(method, label_text, label_options)
          safe_join([check_box_html, label_html])
        else
          super(method, options, checked_value, unchecked_value)
        end
      end
    end

    def radio_button(method, tag_value, options = {})
      wrapper_options = options.delete(:wrapper) || {}
      label_text = options.delete(:label)

      # Set default flex layout for the wrapper
      wrapper_class = "flex items-center justify-start gap-2"
      wrapper_options[:class] = [wrapper_class, wrapper_options[:class]].compact.join(" ")

      content_tag(:div, wrapper_options) do
        add_default_class!(options, "form-input-radio")
        add_error_class!(options) if has_error?(method)

        if label_text
          radio_html = super(method, tag_value, options)
          label_html = label(method, label_text, value: tag_value, class: "form-label")
          safe_join([radio_html, label_html])
        else
          super(method, tag_value, options)
        end
      end
    end

    def file_field(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "form-file")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def rich_text_area(method, options = {})
      field_wrapper(method, options) do
        add_default_class!(options, "trix-content")
        add_error_class!(options) if has_error?(method)
        super(method, options)
      end
    end

    def range_field(method, options = {})
      # Extract wrapper options and add stimulus controller to the form group
      wrapper_options = options.delete(:wrapper) || {}
      wrapper_options["data-controller"] = "railsui-range"

      field_wrapper(method, options.merge(wrapper: wrapper_options)) do
        add_default_class!(options, "form-input-range")
        add_error_class!(options) if has_error?(method)

        # Add stimulus target and action data attributes to the input
        options["data-railsui-range-target"] = "range"
        options["data-action"] = "input->railsui-range#onInput"

        super(method, options)
      end
    end


    def switch_field(method, options = {})
      label_text = options.delete(:label) || method.to_s.humanize

      field_wrapper(method, options.merge(label: false)) do
        add_default_class!(options, "form-input-switch")
        add_error_class!(options) if has_error?(method)

        # Create switch input without hidden field
        switch_html = @template.check_box(@object_name, method, objectify_options(options.merge(include_hidden: false)), "1", "0")
        label_html = label(method, label_text)
        safe_join([switch_html, label_html])
      end
    end

    def button_toggle(method, tag_value, options = {})
      label_text = options.delete(:label) || tag_value.to_s.humanize
      variant = options.delete(:variant) # sm, lg, ghost, muted

      field_wrapper(method, options.merge(label: label_text)) do
        base_class = "form-input-button-toggle"
        base_class += "-#{variant}" if variant
        add_default_class!(options, base_class)

        # Call ActionView radio_button helper directly to avoid flex wrapper
        @template.radio_button(@object_name, method, tag_value, objectify_options(options))
      end
    end

    def label(method, text = nil, options = {})
      add_default_class!(options, "form-label")
      # Check both the required option and model validators
      is_required = options.delete(:required) || required_field?(method)
      options[:class] += " form-label-required" if is_required
      super(method, text, options)
    end

    def error_message(method)
      return unless has_error?(method)

      content_tag(:p, class: "mt-1 text-sm text-red-600 dark:text-red-400") do
        @object.errors[method].join(", ")
      end
    end

    def form_group(method = nil, options = {}, &block)
      content_tag(:div, class: "form-group #{options[:class]}", &block)
    end

    def form_help(text, options = {})
      add_default_class!(options, "form-help text-xs")
      content_tag(:p, text, options)
    end

    def submit(value = nil, options = {})
      add_default_class!(options, "btn btn-primary")
      super(value, options)
    end

    private

    def field_wrapper(method, options = {}, &block)
      wrapper_options = options.delete(:wrapper)
      label_text = options.delete(:label)
      help_text = options.delete(:help)
      skip_label = options.delete(:skip_label) || false
      is_required = options[:required] || false

      # If wrapper is explicitly false, just return the field without wrapping
      if wrapper_options == false
        return capture(&block)
      end

      wrapper_options ||= {}

      form_group(method, wrapper_options) do
        elements = []

        # Add label unless skipped
        unless skip_label
          label_options = options.delete(:label_options) || {}
          # Pass the required flag to the label
          label_options[:required] = is_required if is_required
          elements << label(method, label_text, label_options) if label_text != false
        end

        # Add the field
        elements << capture(&block)

        # Add error message
        elements << error_message(method) if has_error?(method)

        # Add help text
        if help_text
          elements << content_tag(:p, help_text, class: "form-help")
        end

        safe_join(elements)
      end
    end

    def add_default_class!(options, css_class)
      options[:class] = [css_class, options[:class]].compact.join(" ")
    end

    def add_error_class!(options)
      options[:class] = [options[:class], "form-input-error"].compact.join(" ")
    end

    def has_error?(method)
      @object.respond_to?(:errors) && @object.errors[method].present?
    end

    def required_field?(method)
      return false unless @object.class.respond_to?(:validators_on)

      @object.class.validators_on(method).any? do |validator|
        validator.is_a?(ActiveModel::Validations::PresenceValidator)
      end
    end
  end
end
