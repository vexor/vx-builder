require 'spec_helper'
require 'vx/common'

describe Vx::Builder::Task do
  let(:task) { create :task, pull_request_id: 1, deploy: true }
  subject { task }

  context "just created" do
    its(:name)            { should eq 'name' }
    its(:sha)             { should eq 'b665f90239563c030f1b280a434b3d84daeda1bd' }
    its(:deploy_key)      { should be }
    its(:cache_url_prefix){ should eq 'http://example.com' }
    its(:job_id)          { should eq 1 }
    its(:build_id)        { should eq 12 }
    its(:pull_request_id) { should eq 1 }
  end

end
