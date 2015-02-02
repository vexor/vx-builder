require 'spec_helper'
require 'vx/common'

describe Vx::Builder::Task do
  let(:task) { create :task, pull_request_id: 1, deploy: true }
  subject { task }

  context "just created" do
    its(:name)            { should eq 'vexor/vx-test-repo' }
    its(:sha)             { should eq '8f53c077072674972e21c82a286acc07fada91f5' }
    its(:ssh_keys)        { should be }
    its(:cache_url_prefix){ should eq 'http://localhost:3001' }
    its(:job_id)          { should eq 1 }
    its(:build_id)        { should eq 12 }
    its(:pull_request_id) { should eq 1 }
    its(:project_host)    { should eq 'github.com' }
  end

end
