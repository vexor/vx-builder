require 'spec_helper'

describe Vx::Builder::Script::Artifacts do
  let(:app)    { ->(env) { 0 } }
  let(:script) { described_class.new app }
  let(:task)   {  }
  let(:env)    { create :env }
  let(:run)    { script.call env }
  subject { run }

  it { should eq 0 }

  it "should create upload script" do
    subject
    expect(env.after_script).to_not be_empty
  end

end
