# frozen_string_literal: true

# Base component class for Rails UI components
# This avoids conflicts with user's existing ApplicationComponent
class RailsuiComponent < ViewComponent::Base
  private

  def theme
    @theme ||= Railsui.config.theme || 'hound'
  end

  def css_classes(*classes)
    classes.flatten.compact.reject(&:empty?).join(" ")
  end

  def merge_attributes(defaults = {}, **options)
    merged = defaults.dup
    
    if options[:class] && merged[:class]
      merged[:class] = css_classes(merged[:class], options[:class])
    end
    
    merged.merge(options.except(:class))
  end
end