module Railsui
  module ApplicationHelper
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
      when Railsui::Default::THEMES[:hound]
        Railsui::Default::THEME_PREVIEW_LINK[:hound]
      when Railsui::Default::THEMES[:shepherd]
        Railsui::Default::THEME_PREVIEW_LINK[:shepherd]
      else
        nil
      end
    end

    def code(code)
      content_tag :span, html_escape(code), class: "text-neutral-900 font-mono font-semibold text-[15px] dark:text-rose-400 bg-neutral-100 px-1 py-px dark:bg-transparent rounded whitespace-pre"
    end

    def render_snippet(options={})
      active_tab = options[:active_tab] ||= "html"
      html_filename = options[:html_filename] ||= ".html"
      erb_filename = options[:erb_filename] ||= ".html.erb"
      haml_filename = options[:haml_filename] ||= ".haml.erb"
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

    def theme_name
      Railsui.config.theme
    end

    def theme_key
      theme_name.to_sym
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
      content_tag :div, class: "prose prose-sm prose-neutral dark:prose-invert max-w-full" do
        yield
      end
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

    def preview(variant = nil)
      case variant
      when "base"
        "railsui/shared/preview"
      when "zinc"
        "railsui/shared/preview_zinc"
      when "dark_zinc"
        "railsui/shared/preview_dark_zinc"
      when "gray"
        "railsui/shared/preview_gray"
      when "dark"
        "railsui/shared/preview_dark"
      else
        "railsui/shared/preview"
      end
    end

    def quick_link(title: nil, component: nil)
      content_tag :li do
        link_to title.capitalize, "##{component.parameterize}-#{title.parameterize}", class: "text-sm py-1 px-3 rounded font-medium inline-block bg-white border border-slate-300 hover:shadow-sm hover:border-slate-400 dark:border-slate-700 dark:bg-slate-800 dark:hover:border-slate-600 dark:hover:bg-slate-700/80 transition ease-in-out duration-200", data: { action: "click->smooth#scroll" }
      end
    end

    def route_verb_classes(verb)
      case verb
      when "GET"
        "bg-indigo-50 text-indigo-500 dark:bg-indigo-400/50 dark:text-indigo-100"
      when "PATCH"
        "bg-cyan-50 text-cyan-500 dark:bg-cyan-400/50 dark:text-cyan-100"
      when "PUT"
        "bg-amber-50 text-amber-500 dark:bg-amber-400/50 dark:text-amber-100"
      when "POST"
        "bg-emerald-50 text-emerald-500 dark:bg-emerald-400/50 dark:text-emerald-100"
      when "DELETE"
        "bg-rose-50 text-rose-500 dark:bg-rose-400/50 dark:text-rose-100"
      else
        "bg-slate-50 text-slate-500 dark:bg-slate-700 dark:text-slate-100"
      end
    end

    def unavailable_theme?(theme)
      theme[:name] == "Shepherd"
    end

    def tag_label(tag)
      base_classes = "rounded text-xs px-1 py-px font-semibold inline-flex items-center justify-center"

      case tag
      when "marketing"
        content_tag :div, tag.humanize, class: "#{base_classes} bg-indigo-50 text-indigo-500 dark:bg-indigo-500/40 dark:text-indigo-200"
      when "admin"
        content_tag :div, tag.humanize, class: "#{base_classes} bg-sky-50 text-sky-500 dark:bg-sky-500/40 dark:text-sky-200"
      else
        content_tag :div, tag.humanize, class: "#{base_classes} bg-slate-50 text-slate-500 dark:bg-slate-500/40 dark:text-slate-200"
      end
    end

    def theme_colors(group,val)
      Railsui::Default::THEME_COLORS[Railsui.config.theme.to_sym][group][val]
    end
  end
end
