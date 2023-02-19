# HMVC

## Summary

- HMVC is the high-level model of MVC (MVC high-level structure)

- HMVC makes it easy to manage source code and develop projects

## Features

- Generate controller file
- Generate operations file
- Generate forms file
- Generate views file
- Add file creator and creation date

## Installation

Add this line to your application's Gemfile

```ruby
group :development do
  gem 'hmvc-rails', git: 'git@github.com:TOMOSIA-VIETNAM/hmvc-rails.git'
end
```

Then execute

    $ bundle install

And run

    $ rails g hmvc_rails:install

```
create  config/initializers/hmvc.rb
create  app/operations/application_operator.rb
create  app/forms/application_form.rb
```

If it's an API project then you can run

    $ rails g hmvc_rails:install --api

```
create  config/initializers/hmvc.rb
create  app/operations/application_operator.rb
create  app/forms/application_form.rb
create  lib/error_handler/exception.rb
create  lib/error_handler/error_resource.rb
create  lib/error_handler/error_response.rb
```

## Usage

### Default generator

```
rails g hmvc_rails controller_name
```

Example

```
rails g hmvc_rails admin
```

```
create  app/controllers/admin_controller.rb
create  app/operations/admin/index_operator.rb
create  app/operations/admin/show_operator.rb
create  app/operations/admin/new_operator.rb
create  app/operations/admin/create_operator.rb
create  app/operations/admin/edit_operator.rb
create  app/operations/admin/update_operator.rb
create  app/operations/admin/destroy_operator.rb
create  app/forms/admin/new_form.rb
create  app/forms/admin/create_form.rb
create  app/forms/admin/edit_form.rb
create  app/forms/admin/update_form.rb
create  app/views/admin/index.html.erb
create  app/views/admin/show.html.erb
create  app/views/admin/new.html.erb
create  app/views/admin/edit.html.erb
```

### Options

##### 1. If you want to create with action other than default. You can use option `--action` or `-a`

```
rails g hmvc_rails admin -a index show list detail selection
```

##### 2. If you want to create with form action other than default. You can use option `--form`

```
rails g hmvc_rails admin -a index show list detail selection --form index show list
```

##### 3. If you want to create with parent controller other than default. You can use option `--parent`

```
rails g hmvc_rails admin --parent PersonController
```

##### 4. If you want to skip creating the forms file when generate. You can use option `--skip-form`

```
rails g hmvc_rails admin --skip-form
```

Or change configuration `config.form = %w[]`

##### 5. If you want to skip creating the views file when generate. You can use option `--skip-view`

```
rails g hmvc_rails admin --skip-view
```

Or change configuration `config.view = %w[]`

##### 6. Using error handling module if it's an API project

- config/application.rb

```ruby
config.autoload_paths << Rails.root.join('lib')
```

- application_controller.rb

```ruby
include ErrorHandler::ErrorResponse
```

## Configuration

If you want to change the default value when creating the file, please uncomment and update

- config/initializers/hmvc.rb

```ruby
# frozen_string_literal: true
# Created at: 2023-02-18 22:30 +0700
# Creator: thuc.phan@tomosia.com

Hmvc::Rails.configure do |config|
  # The controller files's parent class of controller. Default is ApplicationController
  # config.parent = "ApplicationController"

  # Method when creating the controller files. Default is %w[index show new create edit update destroy]
  # config.action = %w[index show new create edit update destroy]

  # Method when creating the view files. Default is %w[index show new edit]
  # config.view = %w[index show new edit]

  # The form files's parent class. Default is ApplicationForm
  # config.parent_form = "ApplicationForm"

  # Method when creating the form files. Default is %w[new create edit update]
  # config.form = %w[new create edit update]

  # The operation files's parent class. Default is ApplicationOperation
  # config.parent_operation = "ApplicationOperation"

  # Save author name and timestamp to file. Default is true
  # config.file_traces = true
end if Rails.env.development?
```

## Contributing

  - Thuc Phan T. thuc.phan@tomosia.com
  - Minh Tang Q.  minh.tang@tomosia.com

## License

The gem `hmvc-rails` is copyright TOMOSIA VIET NAM CO., LTD

## About [TOMOSIA VIET NAM CO., LTD](https://www.tomosia.com/)

A company that creates new value together with customers and lights the light of happiness

【一緒に】【ハッピー】【ライトアップ】

お客様と共に新たな価値を生み出し幸せの明かりを灯す会社、トモシア

## Test and debug on development environment

- Add gem and run `bundle` (link to gem hmvc-rails project)

```ruby
group :development do
  gem 'hmvc-rails', path: '../../Projects/hmvc-rails'
end
```

- Add `byebug` to the line you want to test

```ruby
def create_controller
  byebug
  template "controller.rb", File.join("app/controllers", class_path.join("/"), "#{file_name}_controller.rb")
end
```

- Run command generator at Rails project terminal

```
rails g hmvc_rails admin
```

```
[31, 40] in /Users/tms/Projects/hmvc-rails/lib/generators/hmvc_rails/hmvc_rails_generator.rb
   31:     validate_skip_view_option
   32:   end
   33:
   34:   def create_controller
   35:     byebug
=> 36:     template "controller.rb", File.join("app/controllers", class_path.join("/"), "#{file_name}_controller.rb")
   37:   end
   38:
   39:   def create_operation
   40:     options[:action].each do |action|
(byebug) options[:action]
["index", "show", "new", "create", "edit", "update", "destroy"]
(byebug)
```

- Code convention check

```
➜  hmvc-rails git:(main) ✗ rubocop
Inspecting 11 files
...........

11 files inspected, no offenses detected
```

- Run unit test

```
➜  hmvc-rails git:(main) ✗ rake test
Run options: --seed 47420

# Running:

.............

Finished in 0.619135s, 20.9970 runs/s, 206.7400 assertions/s.
13 runs, 128 assertions, 0 failures, 0 errors, 0 skips
```
