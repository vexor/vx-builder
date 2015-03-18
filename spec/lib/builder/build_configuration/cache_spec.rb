require 'spec_helper'

describe Vx::Builder::BuildConfiguration::Cache do
  let(:params) { { "directories" => ['/a', '/b'] } }
  let(:env)    { described_class.new params }
  subject { env }

  its(:attributes) { should eq("directories"=>["/a", "/b"], "enabled"=>true) }

  context "attributes" do
    context "when cache is valid hash" do
      let(:params) { {"directories" => ['/a']} }
      it { should be_enabled }
      its(:directories) { should eq ['/a'] }
    end

    context "when cache is invalid hash" do
      let(:params) { {"key" => ['/a']} }
      it { should be_enabled }
      its(:directories) { should eq [] }
    end

    context "when is nil" do
      let(:params) { nil }
      it { should be_enabled }
      its(:directories) { should eq [] }
    end

    context "when is false value" do
      let(:params) { false }
      it { should_not be_enabled }
      its(:directories){ should eq [] }
    end
  end

  it "should expand directories" do
    params = { "directories" => ["bundler", 'npm', 'bower'] }
    cache  = described_class.new(params)
    expect(cache.directories).to eq ["~/.rubygems", "node_modules", "bower_components"]
  end

end
