require 'spec_helper'

describe Vx::Builder::BuildConfiguration::Vexor do
  let(:params) { {
    "timeout"      => "1",
    "read_timeout" => "2"
  } }
  let(:env) { described_class }

  it "should successfuly normalize attributes" do
    p = params
    expect(env.new(p).timeout).to eq 1
    expect(env.new(p).read_timeout).to eq 2

    p = {}
    expect(env.new(p).timeout).to be_nil
    expect(env.new(p).read_timeout).to be_nil

    p = nil
    expect(env.new(p).timeout).to be_nil
    expect(env.new(p).read_timeout).to be_nil

    p = "foo"
    expect(env.new(p).timeout).to be_nil
    expect(env.new(p).read_timeout).to be_nil

    p = %w{ foo }
    expect(env.new(p).timeout).to be_nil
    expect(env.new(p).read_timeout).to be_nil
  end

end
