# Rails UI Form Builder
#
# A custom form builder that automatically applies theme-specific CSS classes
# to form elements based on the configured Rails UI theme.
#
# == Usage
#
# Use with the railui_form_with helper:
#
#   <%= railui_form_with model: @user do |f| %>
#     <%= f.form_group do %>
#       <%= f.label :email %>
#       <%= f.email_field :email, placeholder: "Enter your email" %>
#     <% end %>
#
#     <%= f.form_group do %>
#       <%= f.label :password %>
#       <%= f.password_field :password %>
#     <% end %>
#
#     <%= f.form_group do %>
#       <%= f.label :bio %>
#       <%= f.text_area :bio, rows: 4 %>
#     <% end %>
#
#     <%= f.submit "Sign Up" %>
#   <% end %>
#
# == Supported Form Helpers
#
# All standard Rails form helpers are supported and automatically styled:
# - text_field, email_field, password_field, text_area
# - number_field, telephone_field, url_field, search_field
# - file_field, select, collection_select
# - check_box, radio_button, switch (custom)
# - submit, button, label
#
# == CSS Class Override Strategies
#
# You can customize how CSS classes are applied using the :class_strategy option:
#
# 1. :append (default) - Adds custom classes after theme classes
#    <%= f.text_field :name, class: "w-full" %>
#    # Result: "form-input w-full"
#
# 2. :prepend - Adds custom classes before theme classes
#    <%= f.text_field :name, class: "custom-focus", class_strategy: :prepend %>
#    # Result: "custom-focus form-input"
#
# 3. :replace - Completely replaces theme classes
#    <%= f.text_field :name, class: "my-input", class_strategy: :replace %>
#    # Result: "my-input"
#
# == Form Groups
#
# Use form_group to wrap form elements with consistent spacing:
#
#   <%= f.form_group do %>
#     <%= f.label :title %>
#     <%= f.text_field :title %>
#   <% end %>
#
# Custom wrapper classes:
#   <%= f.form_group wrapper_classes: "mb-8" do %>
#     <%= f.label :title %>
#     <%= f.text_field :title %>
#   <% end %>
#
# == Switch Fields
#
# Rails UI includes a custom switch field (styled checkbox):
#
#   <%= f.form_group do %>
#     <%= f.switch :notifications %>
#     <%= f.label :notifications, "Enable notifications" %>
#   <% end %>
#
# == Configuration
#
# Theme classes can be overridden in an initializer:
#
#   # config/initializers/railsui.rb
#   Railsui.configure do |config|
#     config.override_form_classes('hound', {
#       'input' => 'form-input shadow-lg',
#       'submit' => 'btn btn-primary btn-lg'
#     })
#   end
#
# == Gotchas
#
# 1. Always use rui_form_with, not form_with:
#    ❌ <%= form_with model: @user do |f| %>
#    ✅ <%= railui_form_with model: @user do |f| %>
#
# 2. Switch fields need both the switch and label:
#    <%= f.switch :notifications %>
#    <%= f.label :notifications, "Enable notifications" %>
#
# 3. Select helpers use html_options for classes:
#    <%= f.select :category, options, {}, { class: "custom-class" } %>
#
# 4. Class strategies only work with direct class options:
#    ❌ <%= f.text_field :name, { class: "custom" }, class_strategy: :replace %>
#    ✅ <%= f.text_field :name, class: "custom", class_strategy: :replace %>
#
# 5. Form groups capture blocks - don't use = for the opening tag:
#    ❌ <%= f.form_group do %>
#    ✅ <% f.form_group do %>
#
# 6. Theme classes are applied automatically - you don't need to add them (but you can to overide them):
#    ❌ <%= f.text_field :name, class: "form-input" %>
#    ✅ <%= f.text_field :name %>
# 7. For form_for, use railsui_form_for:
#    ❌ <%= form_for @user do |f| %>
#    ✅ <%= railsui_form_for @user do |f| %>

module Railsui
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Override default form helpers to apply theme classes
    def text_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def email_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def password_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def text_area(method, options = {})
      options = apply_theme_classes(:textarea, options)
      super(method, options)
    end

    def number_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def telephone_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def url_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def search_field(method, options = {})
      options = apply_theme_classes(:input, options)
      super(method, options)
    end

    def file_field(method, options = {})
      options = apply_theme_classes(:file, options)
      super(method, options)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      html_options = apply_theme_classes(:select, html_options)
      super(method, choices, options, html_options, &block)
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      html_options = apply_theme_classes(:select, html_options)
      super(method, collection, value_method, text_method, options, html_options)
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      options = apply_theme_classes(:checkbox, options)
      super(method, options, checked_value, unchecked_value)
    end

    def radio_button(method, tag_value, options = {})
      options = apply_theme_classes(:radio, options)
      super(method, tag_value, options)
    end

    # Custom switch field - essentially a styled checkbox
    # Use with a label for best results:
    #   <%= f.switch :notifications %>
    #   <%= f.label :notifications, "Enable notifications" %>
    def switch(method, options = {}, checked_value = "1", unchecked_value = "0")
      options = apply_theme_classes(:switch, options)
      check_box(method, options, checked_value, unchecked_value)
    end

    def submit(value = nil, options = {})
      options = apply_theme_classes(:submit, options)
      super(value, options)
    end

    def button(value = nil, options = {}, &block)
      options = apply_theme_classes(:button, options)
      super(value, options, &block)
    end

    def label(method, text = nil, options = {}, &block)
      options = apply_theme_classes(:label, options)
      super(method, text, options, &block)
    end

    # Helper method for form groups with automatic styling
    # Wraps form elements in a div with consistent spacing
    #
    # Options:
    #   wrapper_classes: Custom CSS classes for the wrapper div
    #
    # Example:
    #   <%= f.form_group do %>
    #     <%= f.label :email %>
    #     <%= f.email_field :email %>
    #   <% end %>
    def form_group(method = nil, **options, &block)
      wrapper_classes = options.delete(:wrapper_classes) || theme_wrapper_class

      @template.tag.div(class: wrapper_classes) do
        @template.capture(&block)
      end
    end

    private

    # Applies theme-specific CSS classes to form elements
    # Handles different class override strategies
    def apply_theme_classes(component_type, options)
      theme = Railsui.config.theme || 'hound'

      # Get base theme classes
      base_classes = theme_class_mapping(theme, component_type)

      # Handle different override strategies
      final_classes = case options[:class_strategy]&.to_sym
      when :replace
        # Completely replace theme classes with custom ones
        options[:class] || base_classes
      when :prepend
        # Add custom classes before theme classes
        options[:class] ? "#{options[:class]} #{base_classes}" : base_classes
      when :append, nil
        # Default: Add custom classes after theme classes
        options[:class] ? "#{base_classes} #{options[:class]}" : base_classes
      end

      options[:class] = final_classes
      options.delete(:class_strategy) # Remove strategy from final options

      options
    end

    # Maps component types to theme-specific CSS classes
    # Can be overridden via Railsui.config.form_classes
    def theme_class_mapping(theme, component_type)
      # Allow runtime configuration override
      if custom_classes = Railsui.config.form_classes&.dig(theme.to_s, component_type.to_s)
        return custom_classes
      end

      # Default mappings from theme forms.css file
      mappings = {
        'hound' => {
          'input' => 'form-input',
          'textarea' => 'form-textarea',
          'select' => 'form-select',
          'checkbox' => 'form-input-checkbox',
          'radio' => 'form-input-radio',
          'file' => 'form-file',
          'submit' => 'btn btn-primary',
          'switch' => 'form-input-switch',
          'button' => 'btn btn-secondary',
          'label' => 'form-label'
        },
        'shepherd' => {
          'input' => 'form-input',
          'textarea' => 'form-textarea',
          'select' => 'form-select',
          'checkbox' => 'form-input-checkbox',
          'radio' => 'form-input-radio',
          'file' => 'form-file',
          'submit' => 'btn btn-primary',
          'switch' => 'form-input-switch',
          'button' => 'btn btn-secondary',
          'label' => 'form-label'
        }
      }

      mappings.dig(theme, component_type.to_s) || ''
    end

    # Returns the wrapper class for form groups based on current theme
    def theme_wrapper_class
      theme = Railsui.config.theme || 'hound'

      mappings = {
        'hound' => 'form-group',
        'shepherd' => 'form-group'
      }

      mappings[theme] || 'form-group'
    end
  end
end
