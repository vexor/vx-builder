require File.expand_path '../../lib/vx/builder', __FILE__

Bundler.require(:test)
require 'rspec/autorun'
require 'vx/message/testing'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr

  unless ENV['VX_BUILDER_REAL']
    config.filter_run_excluding real: true
  end

  config.before(:each) do
    Vx::Builder.reset_config!
  end
end

