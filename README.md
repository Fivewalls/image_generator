# ImageGenerator

Gem for generating images

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'image_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install image_generator

## Usage

For development:
```
ImageGenerator.configuration.protocol = 'http://'
IMGKit.configure do |config|
  config.wkhtmltoimage = '/usr/local/bin/wkhtmltoimage'
end
ImageGenerator::Base.new.call
```

USAGE:
```
ImageGenerator::Base.new(options).call
```
Possible options: `:width, :height, :category, :rating, :rating_round, :reviews_count`
Default options are `width = 1500`, `height = 400`, `rating_round = 1`

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/image_generator.
