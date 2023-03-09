# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/hmvc/rails"

class TestConfiguration < Minitest::Test
  def test_configuration_properties_are_set_correctly
    configuration = Hmvc::Rails::Configuration.new

    assert_equal "ApplicationController", configuration.parent_controller
    assert_equal %w[index show new create edit update destroy], configuration.action
    assert_equal %w[index show new edit], configuration.view
    assert_equal %w[new create edit update], configuration.form
    assert_equal "ApplicationForm", configuration.parent_form
    assert_equal "ApplicationOperation", configuration.parent_operation
    assert_equal true, configuration.file_traces
  end
end
