# frozen_string_literal: true

require "fileutils"
require "rails/generators/test_case"
require "generators/hmvc_rails/hmvc_rails_generator"

class TestHmvcRailsGenerator < Rails::Generators::TestCase
  tests HmvcRailsGenerator

  def setup
    @tmp_dir = Dir.mktmpdir("hmvc_rails_test")
    FileUtils.cd(@tmp_dir)
  end

  def teardown
    FileUtils.cd("/")
    FileUtils.rm_rf(@tmp_dir)
  end

  def test_default_generator
    run_generator %w[admin]
    assert_file "app/controllers/admin_controller.rb"
    assert_file "app/operations/admin/index_operation.rb"
    assert_file "app/operations/admin/show_operation.rb"
    assert_file "app/operations/admin/new_operation.rb"
    assert_file "app/operations/admin/create_operation.rb"
    assert_file "app/operations/admin/edit_operation.rb"
    assert_file "app/operations/admin/update_operation.rb"
    assert_file "app/operations/admin/destroy_operation.rb"
    assert_file "app/forms/admin/new_form.rb"
    assert_file "app/forms/admin/create_form.rb"
    assert_file "app/forms/admin/edit_form.rb"
    assert_file "app/forms/admin/update_form.rb"
    assert_file "app/views/admin/index.html.erb"
    assert_file "app/views/admin/show.html.erb"
    assert_file "app/views/admin/new.html.erb"
    assert_file "app/views/admin/edit.html.erb"
  end

  def test_controller_template_is_generated
    run_generator %w[admin]
    assert_file "app/controllers/admin_controller.rb", /class AdminController < ApplicationController/
    assert_file "app/controllers/admin_controller.rb", /def index/
    assert_file "app/controllers/admin_controller.rb", /def show/
    assert_file "app/controllers/admin_controller.rb", /def new/
    assert_file "app/controllers/admin_controller.rb", /def edit/
    assert_file "app/controllers/admin_controller.rb", /def create/
    assert_file "app/controllers/admin_controller.rb", /def update/
    assert_file "app/controllers/admin_controller.rb", /def destroy/
  end

  def test_operation_template_is_generated
    run_generator %w[admin]
    assert_file "app/operations/admin/index_operation.rb", /class Admin::IndexOperation < ApplicationOperation/
    assert_file "app/operations/admin/show_operation.rb", /class Admin::ShowOperation < ApplicationOperation/
    assert_file "app/operations/admin/new_operation.rb", /class Admin::NewOperation < ApplicationOperation/
    assert_file "app/operations/admin/create_operation.rb", /class Admin::CreateOperation < ApplicationOperation/
    assert_file "app/operations/admin/edit_operation.rb", /class Admin::EditOperation < ApplicationOperation/
    assert_file "app/operations/admin/update_operation.rb", /class Admin::UpdateOperation < ApplicationOperation/
    assert_file "app/operations/admin/destroy_operation.rb", /class Admin::DestroyOperation < ApplicationOperation/
    assert_file "app/operations/admin/index_operation.rb", /def call/
    assert_file "app/operations/admin/show_operation.rb", /def call/
    assert_file "app/operations/admin/new_operation.rb", /def call/
    assert_file "app/operations/admin/create_operation.rb", /def call/
    assert_file "app/operations/admin/edit_operation.rb", /def call/
    assert_file "app/operations/admin/update_operation.rb", /def call/
    assert_file "app/operations/admin/destroy_operation.rb", /def call/
  end

  def test_form_template_is_generated
    run_generator %w[admin]
    assert_file "app/forms/admin/new_form.rb", /class Admin::NewForm < ApplicationForm/
    assert_file "app/forms/admin/create_form.rb", /class Admin::CreateForm < ApplicationForm/
    assert_file "app/forms/admin/edit_form.rb", /class Admin::EditForm < ApplicationForm/
    assert_file "app/forms/admin/update_form.rb", /class Admin::UpdateForm < ApplicationForm/
    assert_file "app/forms/admin/new_form.rb", /attributes :id/
    assert_file "app/forms/admin/create_form.rb", /attributes :id/
    assert_file "app/forms/admin/edit_form.rb", /attributes :id/
    assert_file "app/forms/admin/update_form.rb", /attributes :id/
  end

  def test_form_template_is_generated_when_form_and_action_match
    run_generator %w[admin -a=index --form=index]
    assert_file "app/forms/admin/index_form.rb"
  end

  def test_form_template_is_not_generated_when_form_and_action_mismatch
    run_generator %w[admin -a=index --form=show]
    assert_no_file "app/forms/admin/index_form.rb"
  end

  def test_generator_with_skip_form_option
    run_generator %w[admin -a=new --skip-form]
    assert_no_file "app/forms/admin/new_form.rb"
  end

  def test_generator_with_skip_view_option
    run_generator %w[admin -a=new --skip-view]
    assert_no_file "app/views/admin/new.html.erb"
  end

  def test_view_template_is_generated_when_view_and_action_match
    run_generator %w[admin -a=index]
    assert_file "app/views/admin/index.html.erb"
  end

  def test_view_template_is_not_generated_when_view_and_action_mismatch
    run_generator %w[admin -a=create]
    assert_no_file "app/views/admin/create.html.erb"
  end
end
