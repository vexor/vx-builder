require 'spec_helper'

describe Vx::Builder::Configuration do
  its(:logger)           { should be }
  its(:casher_ruby)      { should be }
end
