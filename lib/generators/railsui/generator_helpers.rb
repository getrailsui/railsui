module Railsui
  module Generators
    module GeneratorHelpers
      attr_accessor :options, :attributes

      private

      def model_exists?
        File.exist?("#{Rails.root}/app/models/#{singular_name}.rb")
      end

      def model_columns_for_attributes
        class_name.constantize.columns.reject do |column|
          column.name.to_s =~ /^(id|user_id|created_at|updated_at)$/
        end
      end

      def editable_attributes
        attributes ||= if model_exists?
          model_columns_for_attributes.map do |column|
            Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
          end
        else
          []
        end
      end

      def view_files
        actions = %w(index new edit _form)
        actions << 'show' if show_action?
        actions
      end

      def static_files
        %w(about pricing)
      end

      def controller_methods(dir_name)
        all_actions.map do |action|
          read_template("#{dir_name}/#{action}.rb")
        end.join("n").strip
      end

      def source_path(relative_path)
        File.expand_path(File.join("../templates/", relative_path), __FILE__)
      end

      def read_template(relative_path)
        ERB.new(File.read(source_path(relative_path)), nil, '-').result(binding)
      end

      def show_action?
        !options['skip_show']
      end

      def tailwind?
        options['c'] == "tailwind"
      end

      def bootstrap?
        options['c'] == "bootstrap"
      end

      def none?
        !options['c'] || options['c'] == nil
      end
    end
  end
end
