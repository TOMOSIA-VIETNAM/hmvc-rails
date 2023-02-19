# frozen_string_literal: true

require_relative "rails/version"

module Hmvc
  module Rails
    class Error < StandardError; end

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end
    end

    class Configuration
      attr_accessor :parent, :action, :view, :form, :parent_form, :parent_operation, :file_traces

      def initialize
        @parent = "ApplicationController"
        @action = %w[index show new create edit update destroy]
        @view = %w[index show new edit]
        @form = %w[new create edit update]
        @parent_form = "ApplicationForm"
        @parent_operation = "ApplicationOperation"
        @file_traces = true
      end
    end
  end
end
