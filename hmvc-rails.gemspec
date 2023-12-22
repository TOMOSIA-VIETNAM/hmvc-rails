# frozen_string_literal: true

require_relative "lib/hmvc/rails/version"

Gem::Specification.new do |spec|
  spec.name        = "hmvc-rails"
  spec.version     = Hmvc::Rails::VERSION
  spec.authors     = ["thucpt"]
  spec.email       = ["thuc.phan@tomosia.com"]
  spec.summary     = "hmvc-rails is a high-level model for the Rails MVC architecture"
  spec.description = "hmvc-rails is a high-level model for the Rails MVC architecture"
  spec.homepage    = "https://github.com/TOMOSIA-VIETNAM/hmvc-rails"
  spec.license     = "MIT"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables << "hmvc"
  spec.require_paths = ["lib"]
end
