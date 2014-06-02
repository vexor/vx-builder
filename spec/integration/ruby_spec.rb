require 'spec_helper'

describe "(integration) ruby" do
  let(:build_configuration) {
    Vx::Builder::BuildConfiguration.from_yaml(config)
  }
  let(:matrix) { Vx::Builder::Matrix.new build_configuration }
  let(:task)   { create :task }
  let(:script) { Vx::Builder::Script.new(task, source) }
  subject { matrix }

  context "language: ruby" do
    let(:config) { fixture("integration/ruby/language/config.yml") }

    its(:build_configurations) { should have(1).item }

    context "first configuration" do
      let(:source) { matrix.build_configurations.first }
      subject { script }


      before do
=begin
        File.open(fixture_path("integration/ruby/language/before_script.sh"), 'w') do |io|
          io << script.to_before_script
        end
        File.open(fixture_path("integration/ruby/language/after_script.sh"), 'w') do |io|
          io << script.to_after_script
        end
        File.open(fixture_path("integration/ruby/language/script.sh"), 'w') do |io|
          io << script.to_script
        end
=end
      end

      it { should_not be_deploy }
      its(:to_before_script) { should eq fixture("integration/ruby/language/before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/language/script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/language/after_script.sh") }
    end
  end
end
