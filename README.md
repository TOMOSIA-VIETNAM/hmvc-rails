# HMVC-RAILS

## Summary

- hmvc-rails is the high-level model of MVC (MVC high-level structure)

- hmvc-rails makes it easy to manage source code and develop projects

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
  gem 'hmvc-rails'
end
```

Then execute

```
bundle install
```

And run

```
rails g hmvc_rails:install
```

```
create  config/initializers/hmvc.rb
create  app/operations/application_operation.rb
create  app/forms/application_form.rb
create  app/validators/uniqueness_validator.rb
create  app/validators/email_validator.rb
```

If it's an API project then you can run

```
rails g hmvc_rails:install --api
```

```
create  config/initializers/hmvc_rails.rb
create  app/operations/application_operation.rb
create  app/forms/application_form.rb
create  app/validators/uniqueness_validator.rb
create  app/validators/email_validator.rb
create  lib/hmvc_rails/extras/exception.rb
create  lib/hmvc_rails/extras/error_resource.rb
create  lib/hmvc_rails/extras/error_response.rb
insert  config/application.rb
insert  app/controllers/application_controller.rb
```

## Usage

### Default generator

```
rails g hmvc_rails controller_name
```

### Short command

```
hmvc controller_name
```

Example

```
rails g hmvc_rails admin

---

OR

hmvc admin
```

```
create  app/controllers/admin_controller.rb
create  app/operations/admin/index_operation.rb
create  app/operations/admin/show_operation.rb
create  app/operations/admin/new_operation.rb
create  app/operations/admin/create_operation.rb
create  app/operations/admin/edit_operation.rb
create  app/operations/admin/update_operation.rb
create  app/operations/admin/destroy_operation.rb
create  app/forms/admin/new_form.rb
create  app/forms/admin/create_form.rb
create  app/forms/admin/edit_form.rb
create  app/forms/admin/update_form.rb
create  app/views/admin/index.html.erb
create  app/views/admin/show.html.erb
create  app/views/admin/new.html.erb
create  app/views/admin/edit.html.erb
```

### Options (You can also use short command too)

##### 1. If you want to create with action other than default. You can use option `--action`

```
rails g hmvc_rails admin --action index show list detail selection
```

##### 2. If you want to create with form action other than default. You can use option `--form`

```
rails g hmvc_rails admin --action index show list detail selection --form index show list
```

##### 3. If you want to create with parent controller other than default. You can use option `--parent-controller`

```
rails g hmvc_rails admin --parent-controller PersonController
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

## Configuration

If you want to change the default value when creating the file, please uncomment and update

_config/initializers/hmvc.rb_

```ruby
# frozen_string_literal: true

# Created at: 2023-02-18 22:30 +0700
# Creator: thuc.phan@tomosia.com

if Rails.env.development?
  Hmvc::Rails.configure do |config|
    # The controller files's parent class of controller. Default is ApplicationController
    # config.parent_controller = "ApplicationController"

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
  end
end
```

## Rollback generator

If you want to rollback the hmvc-rails generator. You can run command

```
rails d hmvc_rails controller_name
```

- - -

## Test and debug gem on development environment

- Add gem and run `bundle` (link to gem hmvc-rails project)

```ruby
group :development do
  gem 'hmvc-rails', path: '../../Projects/hmvc-rails'
  gem 'pry'
end
```

- Add `binding.pry` to the line you want to test

```ruby
require 'pry'
...
def create_controller
  binding.pry
  template "controller.rb", File.join("app/controllers", class_path.join("/"), "#{file_name}_controller.rb")
end
```

- Run command generator at Rails project terminal

```
rails g hmvc_rails admin
```

```
   37: def create_controller
=> 38:   binding.pry
   39:   template "controllers/controller.rb",
   40:            File.join("app/controllers", class_path.join("/"), "#{file_name}_controller.rb")
   41: end

[1] pry(#<HmvcRailsGenerator>)> options[:action]
=> ["index", "show", "new", "create", "edit", "update", "destroy"]
[2] pry(#<HmvcRailsGenerator>)>
```

- Code convention check

```
➜  hmvc-rails git:(main) rubocop
Inspecting 14 files
..............

14 files inspected, no offenses detected
```

- Run unit test

```
➜  hmvc-rails git:(main) ✗ rake test
Run options: --seed 9122

# Running:

.............

Finished in 0.721364s, 18.0214 runs/s, 166.3515 assertions/s.
13 runs, 120 assertions, 0 failures, 0 errors, 0 skips
```

## Configure rubocop

If your project used rubocop for code convention. You can add the below configuration for some conventional hmvc-rails

_.rubocop.yml_

```ruby
require: rubocop/cop/hmvc_rails_cops

HmvcRails/OperatingStyle:
  Enabled: true
  Include:
    - app/operations/**/*.rb

HmvcRails/FormalStyle:
  Enabled: true
  Include:
    - app/forms/**/*.rb
```

Example hmvc-rails offenses

```
➜  demo git:(master) ✗ rubocop
Inspecting 48 files
......C......C..................................

Offenses:

app/forms/admin/new_form.rb:6:1: C: HmvcRails/FormalStyle: The form filename does not match the desired format
class Admin::NewFormm < ApplicationForm ...
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
app/operations/admin/new_operation.rb:6:1: C: HmvcRails/OperatingStyle: The operation filename does not match the desired format
class Admin::NewOperationn < ApplicationOperation ...
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
app/operations/admin/new_operation.rb:7:3: C: HmvcRails/OperatingStyle: Method works in "call" without prefix "step_"
  def call ...
  ^^^^^^^^

48 files inspected, 3 offenses detected
```

## License

The gem `hmvc-rails` is copyright TOMOSIA VIET NAM CO., LTD

## Contributor

  - Thuc Phan T. thuc.phan@tomosia.com
  - Minh Tang Q. minh.tang@tomosia.com

## About [TOMOSIA VIET NAM CO., LTD](https://www.tomosia.com/)

A company that creates new value together with customers and lights the light of happiness

【一緒に】【ハッピー】【ライトアップ】

お客様と共に新たな価値を生み出し幸せの明かりを灯す会社、トモシア
