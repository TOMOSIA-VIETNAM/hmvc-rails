# frozen_string_literal: true

require "rails/generators"

class HmvcRailsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :action, type: :array, default: Hmvc::Rails.configuration.action, aliases: "-a"
  class_option :form, type: :array, default: Hmvc::Rails.configuration.form
  class_option :parent, type: :string, default: Hmvc::Rails.configuration.parent
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
    validate_name
    validate_params
    validate_form_option
    validate_action_option
    validate_parent_option
    validate_skip_form_option
    validate_skip_view_option
  end

  def create_controller
    template "controller.rb", File.join("app/controllers", class_path.join("/"), "#{file_name}_controller.rb")
  end

  def create_operation
    options[:action].each do |action|
      @_action = action
      template "operation.rb", File.join("app/operations", file_path, "#{action}_operation.rb")
    end
  end

  def create_form
    return if options[:skip_form] || options[:form].blank?

    forms = options[:form] & options[:action]
    return puts "Warn: No forms created! Form and action controller does mismatch" if forms.blank?

    forms.each do |action|
      @_action = action
      template "form.rb", File.join("app/forms", file_path, "#{action}_form.rb")
    end
  end

  def create_view
    return if options[:skip_view] || Hmvc::Rails.configuration.view.blank?

    views = Hmvc::Rails.configuration.view & options[:action]
    return puts "Warn: No views created! View and action controller does mismatch" if views.blank?

    view_engine = Rails.application&.config&.generators&.options&.dig(:rails, :template_engine) || "erb"
    copy_view_template(views, view_engine)
  rescue StandardError
    copy_view_template(views, "erb")
  end

  def copy_view_template(views, view_engine)
    views.each do |action|
      @_action = action
      template "view.#{view_engine}", File.join("app/views", file_path, "#{action}.html.#{view_engine}")
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
    wrong_options = option_params - %w[--action --form --parent --skip-form --skip-view -a]
    show_error_message("Invalid optional arguments '#{wrong_options.join(", ")}'") if wrong_options.present?
  end

  def validate_action_option
    action_options = argv.select { |arg| %w[--action -a].include?(arg) }
    show_error_message("Optional '--action' is duplicated") if action_options.size > 1
  end

  def validate_form_option
    form_options = argv.select { |arg| arg == "--form" }
    show_error_message("Optional '--form' is duplicated") if form_options.size > 1
  end

  def validate_parent_option
    parent_options = argv.select { |arg| arg == "--parent" }
    show_error_message("Optional '--parent' is duplicated") if parent_options.size > 1
    index = argv.index("--parent")
    return unless index

    if argv[index + 1].blank? || argv[index + 1].start_with?("-") ||
       (argv[index + 2] && !argv[index + 2].start_with?("-"))
      show_error_message("Option '--parent' is not valid")
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
    url = "#{class_path.join("/")}/#{file_name}"
    case action
    when "index" then "# [GET] #{url}"
    when "show" then "# [GET] #{url}/:id"
    when "new" then "# [GET] #{url}/new"
    when "edit" then "# [GET] #{url}/:id/edit"
    when "create" then "# [POST] #{url}"
    when "update" then "# [PUT] #{url}/:id"
    when "destroy" then "# [DELETE] #{url}/:id"
    else "# [METHOD] #{url}/..."
    end
  end

  def add_file_traces
    return unless Hmvc::Rails.configuration.file_traces

    "# Created at: #{Time.now.strftime("%Y-%m-%d %H:%M %z")}\n# Creator: #{`git config user.email`}"
  end
end
