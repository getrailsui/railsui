module Railsui
  module ApplicationHelper
    def render_svg(name, options = {})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:class] = options.fetch(:styles, "fill-current text-neutral-500")

      filename = "#{name}.svg"
      inline_svg_tag(filename, options)
    end

    def form_input
      "border-gray-300 rounded focus:border-indigo-300 focus:outline-none focus:shadow-none focus:ring-indigo-50 focus:ring-4 ring-transparent ring-2 dark:text-slate-100 dark:focus:ring-indigo-600/50 dark:bg-slate-900 dark:border-slate-600 dark:focus:border-slate-300"
    end

    def select_classes
      "form-select #{form_input}"
    end

    def input_classes
      "form-input #{form_input}"
    end

    def nav_link_to(name = nil, options = {}, html_options = {}, &block)
      if block
        html_options = options
        options = name
        name = block
      end

      url = url_for(options)
      starts_with = html_options.delete(:starts_with)
      html_options[:class] = Array.wrap(html_options[:class])
      active_class = html_options.delete(:active_class) || "nav-link-active"
      inactive_class = html_options.delete(:inactive_class) || ""

      active = if (paths = Array.wrap(starts_with)) && paths.present?
        paths.any? { |path| request.path.start_with?(path) }
      else
        request.path == url
      end

      classes = active ? active_class : inactive_class
      html_options[:class] << classes unless classes.empty?

      html_options.except!(:class) if html_options[:class].empty?

      return link_to url, html_options, &block if block

      link_to name, url, html_options
    end

    def theme_preview_link(theme)
      case theme
      when Railsui::Default::THEMES[:bootstrap][:retriever]
        Railsui::Default::THEME_PREVIEW_LINK[:retriever]
      when Railsui::Default::THEMES[:bootstrap][:setter]
        Railsui::Default::THEME_PREVIEW_LINK[:setter]
      when Railsui::Default::THEMES[:tailwind][:hound]
        Railsui::Default::THEME_PREVIEW_LINK[:hound]
      when Railsui::Default::THEMES[:tailwind][:shepherd]
        Railsui::Default::THEME_PREVIEW_LINK[:shepherd]
      else
        nil
      end
    end

    def code(code)
      content_tag :span, html_escape(code), class: "text-indigo-900 font-mono font-semibold text-[15px] dark:text-rose-400 bg-indigo-50/50 p-px dark:bg-transparent rounded whitespace-pre"
    end

    def render_snippet(options={})
      active_tab = options[:active_tab] ||= "html"
      html_filename = options[:html_filename] ||= ".html"
      erb_filename = options[:erb_filename] ||= ".html.erb"
      haml_filename = options[:haml_filename] ||= ".haml"
      js_filename = options[:js_filename] ||= ".js"
      ruby_filename = options[:ruby_filename] ||= ".rb"


      render partial: "railsui/shared/snippet", locals: {
        active_tab: active_tab,
        html_filename: html_filename,
        erb_filename: erb_filename,
        haml_filename: haml_filename,
        js_filename: js_filename,
        ruby_filename: ruby_filename
      }
    end

    def framework_name
      Railsui.config.css_framework
    end

    def theme_name
      Railsui.config.theme
    end

    def icon(name, options={})
      options[:title] ||= name.underscore.humanize
      options[:aria] = true
      options[:nocomment] = true
      options[:variant] ||= :outline
      options[:class] = options.fetch(:classes, nil)

      filename = "icons/#{options[:variant]}/#{name}.svg"
      inline_svg_tag(filename, options)
    end

    def heading(options={})
      text = options[:text] || "Enter some text"
      tag = options[:tag] || :h2
      id = options[:id]
      classes = options[:class]

      content_tag tag.to_sym, text, id: id, class: classes, data: {
        action: "click->anchor#copy",
        controller: "anchor",
        anchor_url_value: url_for(only_path: false)
      }
    end

    def about_page_exists?
      Rails.root.join("app/views/static/about.html.erb").exist? && Railsui.config.about?
    end

    def pricing_page_exists?
      Rails.root.join("app/views/static/pricing.html.erb").exist? && Railsui.config.pricing?
    end

    def design_system_navgiation_state
      if params["controller"].include?("authentication")
        false
      elsif content_for(:fullwidth).present?
        false
      else
        true
      end
    end

    def email_viewer(subject="A sample subject", &block)
      render "railsui/shared/rui_email_preview", subject: subject, block: block, flush: true
    end

    def box_label_classes(options={})
      "rounded-lg bg-white shadow-sm border border-slate-200 block select-none hover:shadow-none group bg-gradient-to-br from-white to-slate-50 dark:from-slate-700 dark:to-slate-800 dark:border-slate-600 dark:shadow-sm #{options[:offset] == false ? "px-4 pb-4 pt-1" : "p-4" }"
    end

    def box_check_classes
      "text-indigo-600 form-checkbox rounded focus:outline-none ring-2 ring-transparent focus:ring-slate-100  mr-2 border-slate-500 w-5 h-5
      focus:dark:ring-slate-700
      focus:dark:ring-opacity-20
      focus:dark:bg-slate-600  dark:bg-slate-700
      dark:ring-transparent"
    end

    def help_text &block
      content_tag :div, class: "prose prose-sm prose-p:text-slate-600 prose-a:text-indigo-500 dark:prose-invert max-w-full my-2" do
        yield
      end
    end

    def unsplash_url(options={})
      item = options[:item] ||= "dog"
      width = options[:width] ||= "600"
      height = options[:height] ||= "400"
      "https://source.unsplash.com/random/#{width}×#{height}/?#{item}"
    end

    def doc_label(type)
      case type
      when :javascript
        content_tag :p, "JavaScript", class:"bg-yellow-300 text-black rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :stimulus
        content_tag :p, "Stimulus.js", class: "bg-yellow-300 text-black rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :ruby
        content_tag :p, "Ruby", class: "bg-red-700 text-white rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :tutorial
        content_tag :p, "Tutorial", class: "bg-blue-500 text-white rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      when :demo
        content_tag :p, "Demo", class: "bg-emerald-50 text-emerald-600 rounded-full px-3 py-1 font-semibold inline-block text-xs mb-3"
      end
    end

    def callout
      "railsui/shared/callout"
    end

    def preview
      "railsui/shared/preview"
    end
  end
end
