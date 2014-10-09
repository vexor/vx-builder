require 'spec_helper'

describe Vx::Builder::BuildConfiguration::Env do
  let(:params) { { 'matrix' => ['a', 'b'], 'global' => ['c', 'd'] } }
  let(:env)    { described_class.new params }
  subject { env }

  its(:attributes) { should eq("matrix" => ['a', 'b'], "global" => ['c', 'd']) }

  context "attributes" do

    context "when env is string" do
      let(:params) { 'foo' }
      its(:matrix)     { should eq [] }
      its(:global)     { should eq ["foo"] }
    end

    context "when env is array" do
      let(:params) { %w{foo bar} }
      its(:matrix)     { should eq ['foo', 'bar'] }
      its(:global)     { should eq [] }
    end

    context "when env is array of one element" do
      let(:params) { ["foo"] }
      its(:matrix)     { should eq [] }
      its(:global)     { should eq ['foo'] }
    end

    context "when env is valid hash" do
      let(:params) { { "global" => "foo", "matrix" => 'bar' } }
      its(:matrix)     { should eq ['bar'] }
      its(:global)     { should eq ['foo'] }
    end

    context "when env is invalid hash" do
      let(:params) { { "key" => "foo" } }
      its(:matrix)     { should eq [] }
      its(:global)     { should eq [] }
    end

    context "hen env has secure keys" do
      let(:params) { [{secure: "foo"}] }
      its(:attributes) { should eq({"global" => [], "matrix" => []}) }
    end

  end
end
