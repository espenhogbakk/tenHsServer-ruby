require 'factory_girl'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
end

require 'mocha/setup'
require 'webmock/test_unit'