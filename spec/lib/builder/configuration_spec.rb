require 'spec_helper'

describe Vx::Builder::Configuration do
  its(:logger)           { should be }
  its(:webdav_cache_url) { should be_nil }
  its(:casher_ruby)      { should be }
end
