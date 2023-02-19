# frozen_string_literal: true

require "rails"
require "rails/generators"

module HmvcRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Generate base files of the HMVC structure"

      class_option :api, type: :boolean, default: false

      source_root File.expand_path("templates", __dir__)

      def generate
        copy_configuration
        copy_application_operator
        copy_application_form
        copy_validator
        copy_api_error_handler
        add_config_api_error_response
        add_api_error_response
      end

      private

      def copy_configuration
        file_selected = options[:api] ? "configures/hmvc_rails_api.rb" : "configures/hmvc_rails.rb"
        template file_selected, "config/initializers/hmvc_rails.rb"
      end

      def copy_application_operator
        template "operations/application_operation.rb", "app/operations/application_operation.rb"
      end

      def copy_application_form
        template "forms/application_form.rb", "app/forms/application_form.rb"
      end

      def copy_validator
        template "validators/uniqueness_validator.rb", "app/validators/uniqueness_validator.rb"
        template "validators/email_validator.rb", "app/validators/email_validator.rb"
      end

      def copy_api_error_handler
        return unless options[:api]

        template "extras/exception.rb", "lib/hmvc_rails/extras/exception.rb"
        template "extras/error_resource.rb", "lib/hmvc_rails/extras/error_resource.rb"
        template "extras/error_response.rb", "lib/hmvc_rails/extras/error_response.rb"
      end

      # rubocop:disable Layout/LineLength
      def add_config_api_error_response
        return if Rails.root.blank? || !options[:api] || behavior == :revoke

        file_path = Rails.root.join("config", "application.rb")
        if File.foreach(file_path).grep(/Application < Rails::Application/).any?
          inject_into_file file_path, "    # This setting to use the error handler of hmvc-rails\n    config.eager_load_paths << Rails.root.join('lib', 'hmvc_rails')\n\n", after: "Application < Rails::Application\n"
        else
          puts "Warning: The hmvc_rails module could not be automatically loaded because the \"Application < Rails::Application\" flag was not found"
          puts "Please manually add `config.eager_load_paths << Rails.root.join('lib', 'hmvc_rails')` to your `config/application.rb` to use hmvc-rails error response"
        end
      end

      def add_api_error_response
        return if Rails.root.blank? || !options[:api] || behavior == :revoke

        file_path = Rails.root.join("app", "controllers", "application_controller.rb")
        if File.foreach(file_path).grep(/ApplicationController < ActionController::API/).any?
          inject_into_file file_path, "  include Extras::ErrorResponse\n", after: "ApplicationController < ActionController::API\n"
        else
          puts "Warning: The error response module could not be automatically added because the \"ApplicationController < ActionController::API\" flag was not found"
          puts "Please manually add `include Extras::ErrorResponse` to your application_controller.rb to use hmvc-rails error response"
        end
      end
      # rubocop:enable Layout/LineLength

      def add_file_traces
        "# Created at: #{Time.now.strftime("%Y-%m-%d %H:%M %z")}\n# Creator: #{`git config user.email`}"
      end
    end
  end
end
