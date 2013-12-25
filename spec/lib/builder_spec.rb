require 'spec_helper'

describe Vx::Builder do
  subject { described_class }

  its(:logger) { should be }
  its(:config) { should be }

  context ".configure" do
    it "should change configuration" do
      subject.configure do |c|
        c.casher_ruby = 'ruby'
      end
      expect(subject.config.casher_ruby).to eq 'ruby'
    end
  end
end
