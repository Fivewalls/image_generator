lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "image_generator/version"

Gem::Specification.new do |spec|
  spec.name          = "image_generator"
  spec.version       = ImageGenerator::VERSION
  spec.authors       = ["Volodymyr Partyka"]
  spec.email         = ["vovuk097@gmail.com"]

  spec.summary       = "Image generator gem"
  spec.homepage      = "https://github.com/Fivewalls/image_generator"
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files         = [
    "README.md","LICENSE",
    "lib/assets/images/wall.png",
    "lib/views/categories/rating.slim",
    "lib/views/categories/reviews.slim"
  ]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_dependency "font-awesome-rails", "~> 4.7", ">= 4.7.0.4"
  spec.add_dependency "imgkit", "~> 1.6", ">= 1.6.2"
  spec.add_dependency "wkhtmltoimage-binary", "~> 0.12.5"
  spec.add_dependency "rails", ">= 4.2.9"
  spec.add_dependency "slim-rails", "~> 3.2"
end
