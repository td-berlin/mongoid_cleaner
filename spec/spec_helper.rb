$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mongoid_cleaner'
require 'mongoid'

Mongoid.configure do |config|
  config.connect_to('mongoid-cleaner-test')
end

# :nodoc:
class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :login
  field :email
end

# :nodoc:
class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
end

RSpec.configure do |config|
  config.after(:suite) do
    Mongoid::Config.purge!
  end
end
