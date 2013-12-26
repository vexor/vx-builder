require 'spec_helper'
require 'vx/common'

describe Vx::Builder::Task do
  let(:task) {
    described_class.new(
      'name',
      'source',
      'sha',
      deploy_key: 'deploy_key',
      pull_request_id: '1'
    )
  }

  subject { task }

  context "just created" do
    let(:name)            { should eq 'name' }
    let(:source)          { should eq 'source' }
    let(:sha)             { should eq 'sha' }
    let(:deploy_key)      { should eq 'deploy_key' }
    let(:pull_request_id) { should eq '1' }
  end

end
