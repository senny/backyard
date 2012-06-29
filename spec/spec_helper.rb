require File.join(File.dirname(__FILE__), '..', 'lib', 'backyard')
require 'factory_girl'
require 'backyard/adapter/factory_girl'

if defined?(FactoryGirl)
  FactoryGirl.find_definitions
else
  Factory.find_definitions
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true
end
