require File.expand_path '../../lib/vx/builder', __FILE__

Bundler.require(:test)
require 'rspec/autorun'
require 'vx/message/testing'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr

  config.before(:each) do
    Vx::Builder.reset_config!
  end
end

