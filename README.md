# MongoidCleaner

MongoidCleaner with drop and truncation strategy

## Why?

* [database_cleaner](https://github.com/DatabaseCleaner/database_cleaner) exists
but it don't support [MongoDB 3](https://github.com/DatabaseCleaner/database_cleaner/issues/348).

* Also we discovered that droping collection is more faster than truncation
  strategy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_cleaner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_cleaner

## Usage

With rspec:

~~~ ruby
RSpec.configure do |config|
  config.before(:suite) do
    MongoidCleaner.strategy = :drop
  end

  config.around(:each) do |example|
    MongoidCleaner.cleaning do
      example.run
    end
  end
end
~~~

Without rspec:

~~~ ruby
MongoidCleaner.strategy = 'drop', { only: %w(users) }
MongoidCleaner.clean
# dirty mongo
MongoidCleaner.strategy = 'truncate', { except: %w(users) }
MongoidCleaner.clean
~~~

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Tests

Unit testing:

~~~
bundle exec rake test
~~~

Code style:

~~~
bundle exec rubocop
~~~

## Contributing

1. Fork it ( https://github.com/td-berlin/mongoid_cleaner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
