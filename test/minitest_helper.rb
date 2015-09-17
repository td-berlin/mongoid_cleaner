require 'minitest/autorun'
require 'mongoid'
require 'mongoid_cleaner'

Mongoid.configure do |config|
  config.connect_to 'mongoid-cleaner-test'
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

Minitest.after_run { Mongoid::Config.purge! }
