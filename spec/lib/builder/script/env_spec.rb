require 'spec_helper'

describe Vx::Builder::Script::Env do
  let(:app)    { ->(_) { 0 } }
  let(:script) { described_class.new app }
  let(:env)    { create :env }
  let(:run)    { script.call env }
  subject { run }

  it { should eq 0 }

end
