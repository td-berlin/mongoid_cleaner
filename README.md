# MongoidCleaner
[![Build Status](https://travis-ci.org/td-berlin/mongoid_cleaner.svg)](https://travis-ci.org/td-berlin/mongoid_cleaner)

MongoidCleaner is an alternative for [DatabaseCleaner](https://github.com/DatabaseCleaner/database_cleaner)
for projects using [MongoDB](https://www.mongodb.org/) along with [Mongoid](http://mongoid.org/en/mongoid/index.html).
Besides the `truncate` strategy, this gem also provides faster `drop` strategy. It runs with Mongoid versions 4 and 5.


## Why?

DatabaseCleaner always served our needs well, unfortunately it didn't support [MongoDB 3 running on Wired Tiger](https://github.com/DatabaseCleaner/database_cleaner/pull/343)
for quite some time, so we decided to build our own specialised solution.

Also, removing all the documents from a collection requires much more work: Freeing the document's storage, clearing the index entries that point to the document, etc..
The benefit of simply dropping a collection is that it is much faster.

## Possible drawbacks

We haven't experienced any problems so far, but dropping a collection will also remove the collections indexes.
Feel free to report any issues related to that.

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
