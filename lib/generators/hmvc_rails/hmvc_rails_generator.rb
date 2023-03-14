# frozen_string_literal: true

require "rails/generators"

class HmvcRailsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :action, type: :array, default: Hmvc::Rails.configuration.action
  class_option :form, type: :array, default: Hmvc::Rails.configuration.form
  class_option :parent_controller, type: :string, default: Hmvc::Rails.configuration.parent_controller
  class_option :skip_form, type: :boolean, default: false
  class_option :skip_view, type: :boolean, default: false

  def generate
    validate_options
    create_controller
    create_operation
    create_form
    create_view
  end

  private

  def validate_options
    return if behavior == :revoke

    validate_name
    validate_params
    validate_form_option
    validate_action_option
    validate_parent_controller_option
    validate_skip_form_option
    validate_skip_view_option
  end

  def create_controller
    template "controllers/controller.rb",
             File.join("app/controllers", class_path.join("/"), "#{file_name}_controller.rb")
  end

  def create_operation
    options[:action].each do |action|
      @_action = action
      template "operations/operation.rb", File.join("app/operations", file_path, "#{action}_operation.rb")
    end
  end

  def create_form
    return if options[:skip_form] || options[:form].blank?

    forms = options[:form] & options[:action]
    return puts "Warning: No forms created! Form and action controller does mismatch" if forms.blank?

    forms.each do |action|
      @_action = action
      template "forms/form.rb", File.join("app/forms", file_path, "#{action}_form.rb")
    end
  end

  def create_view
    return if options[:skip_view] || Hmvc::Rails.configuration.view.blank?

    views = Hmvc::Rails.configuration.view & options[:action]
    return puts "Warning: No views created! View and action controller does mismatch" if views.blank?

    view_engine = Rails.application&.config&.generators&.options&.dig(:rails, :template_engine) || "erb"
    copy_view_template(views, view_engine)
  rescue StandardError
    copy_view_template(views, "erb")
  end

  def copy_view_template(views, view_engine)
    views.each do |action|
      @_action = action
      template "views/view.#{view_engine}", File.join("app/views", file_path, "#{action}.html.#{view_engine}")
    end
  end

  def argv
    @argv ||= ARGV.map { |arg| arg.split("=") }.flatten
  end

  def validate_name
    show_error_message("Invalid name arguments '#{argv[1]}'") if argv[1] && !argv[1].start_with?("-")
  end

  def validate_params
    option_params = argv.select { |arg| arg.include?("-") }
    wrong_options = option_params - %w[--action --form --parent-controller --skip-form --skip-view]
    show_error_message("Invalid optional arguments '#{wrong_options.join(", ")}'") if wrong_options.present?
  end

  def validate_action_option
    action_options = argv.select { |arg| arg == "--action" }
    show_error_message("Optional '--action' is duplicated") if action_options.size > 1
  end

  def validate_form_option
    form_options = argv.select { |arg| arg == "--form" }
    show_error_message("Optional '--form' is duplicated") if form_options.size > 1
  end

  def validate_parent_controller_option
    parent_options = argv.select { |arg| arg == "--parent-controller" }
    show_error_message("Optional '--parent-controller' is duplicated") if parent_options.size > 1
    index = argv.index("--parent-controller")
    return unless index

    if argv[index + 1].blank? || argv[index + 1].start_with?("-") ||
       (argv[index + 2] && !argv[index + 2].start_with?("-"))
      show_error_message("Option '--parent-controller' is not valid")
    end
  end

  def validate_skip_form_option
    index = argv.index("--skip-form")
    return if index.blank? || argv[index + 1].blank? || argv[index + 1].start_with?("-")

    show_error_message("Option '--skip-form' is not valid")
  end

  def validate_skip_view_option
    index = argv.index("--skip-view")
    return if index.blank? || argv[index + 1].blank? || argv[index + 1].start_with?("-")

    show_error_message("Option '--skip-view' is not valid")
  end

  def show_error_message(message)
    puts "Error:"
    puts "  #{message}"
    puts "------"
    puts `rails g hmvc_rails --help`
    exit(1)
  end

  def path_notes(action)
    case action
    when "index" then "# [GET]..."
    when "show" then "# [GET]..."
    when "new" then "# [GET]..."
    when "edit" then "# [GET]..."
    when "create" then "# [POST]..."
    when "update" then "# [PUT]..."
    when "destroy" then "# [DELETE]..."
    else "# [METHOD]..."
    end
  end

  def add_file_traces
    return unless Hmvc::Rails.configuration.file_traces

    "# Created at: #{Time.now.strftime("%Y-%m-%d %H:%M %z")}\n# Creator: #{`git config user.email`}"
  end
end
