# frozen_string_literal: true

require "rails/generators"

module HmvcRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Generate base files of the HMVC structure"

      class_option :api, type: :boolean, default: false

      source_root File.expand_path("templates", __dir__)

      def generate
        copy_initializers_config
        copy_application_operator
        copy_application_form
        copy_api_error_handler
      end

      private

      def copy_initializers_config
        file_selected = options[:api] ? "hmvc_rails_api.rb" : "hmvc_rails.rb"
        template file_selected, "config/initializers/hmvc_rails.rb"
      end

      def copy_application_operator
        template "application_operation.rb", "app/operations/application_operation.rb"
      end

      def copy_application_form
        template "application_form.rb", "app/forms/application_form.rb"
      end

      def copy_api_error_handler
        return unless options[:api]

        template "exception.rb", "lib/error_handler/exception.rb"
        template "error_resource.rb", "lib/error_handler/error_resource.rb"
        template "error_response.rb", "lib/error_handler/error_response.rb"
      end

      def add_file_traces
        "# Created at: #{Time.now.strftime("%Y-%m-%d %H:%M %z")}\n# Creator: #{`git config user.email`}"
      end
    end
  end
end
