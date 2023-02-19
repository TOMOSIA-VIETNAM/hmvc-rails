# frozen_string_literal: true

require "fileutils"
require "rails/generators/test_case"
require "generators/hmvc_rails/install_generator"

class TestInstallGenerator < Rails::Generators::TestCase
  tests HmvcRails::Generators::InstallGenerator

  def setup
    @tmp_dir = Dir.mktmpdir("hmvc_rails_test")
    FileUtils.cd(@tmp_dir)
  end

  def teardown
    FileUtils.cd("/")
    FileUtils.rm_rf(@tmp_dir)
  end

  def test_install_generator
    run_generator

    assert_file "config/initializers/hmvc_rails.rb"
    assert_file "app/operations/application_operation.rb"
    assert_file "app/forms/application_form.rb"
  end

  def test_api_install_generator
    run_generator ["--api"]

    assert_file "config/initializers/hmvc_rails.rb"
    assert_file "app/operations/application_operation.rb"
    assert_file "app/forms/application_form.rb"
    assert_file "lib/error_handler/exception.rb"
    assert_file "lib/error_handler/error_resource.rb"
    assert_file "lib/error_handler/error_response.rb"
  end
end
