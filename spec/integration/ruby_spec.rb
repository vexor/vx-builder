require 'spec_helper'

describe "(integration) ruby" do
  let(:build_configuration) {
    Vx::Builder::BuildConfiguration.from_yaml(config)
  }
  let(:matrix) { Vx::Builder::Matrix.new build_configuration }
  let(:task)   { create :task }
  let(:script) { Vx::Builder::Script.new(task, source) }
  subject { matrix }

  context "language" do
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

  context "deploy" do
    let(:config) { fixture("integration/ruby/deploy/config.yml") }

    context "configuration" do
      let(:task)   { create :task, deploy: true }
      let(:source) { matrix.deploy_configuration("master") }
      subject { script }

      before do
=begin
        File.open(fixture_path("integration/ruby/deploy/d.before_script.sh"), 'w') do |io|
          io << script.to_before_script
        end
        File.open(fixture_path("integration/ruby/deploy/d.after_script.sh"), 'w') do |io|
          io << script.to_after_script
        end
        File.open(fixture_path("integration/ruby/deploy/d.script.sh"), 'w') do |io|
          io << script.to_script
        end
=end
      end

      it "should have source" do
        expect(source).to be
      end

      it { should be_deploy }
      its(:to_before_script) { should eq fixture("integration/ruby/deploy/d.before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/deploy/d.script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/deploy/d.after_script.sh") }
    end
  end

  context "matrix" do
    let(:config) { fixture("integration/ruby/matrix/config.yml") }

    its(:build_configurations) { should have(2).item }

    context "0th configuration" do
      let(:source) { matrix.build_configurations[0] }
      subject { script }

      before do
=begin
        File.open(fixture_path("integration/ruby/matrix/0.before_script.sh"), 'w') do |io|
          io << script.to_before_script
        end
        File.open(fixture_path("integration/ruby/matrix/0.after_script.sh"), 'w') do |io|
          io << script.to_after_script
        end
        File.open(fixture_path("integration/ruby/matrix/0.script.sh"), 'w') do |io|
          io << script.to_script
        end
=end
      end

      it { should_not be_deploy }
      its(:to_before_script) { should eq fixture("integration/ruby/matrix/0.before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/matrix/0.script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/matrix/0.after_script.sh") }
    end

    context "1th configuration" do
      let(:source) { matrix.build_configurations[1] }
      subject { script }

      before do
=begin
        File.open(fixture_path("integration/ruby/matrix/1.before_script.sh"), 'w') do |io|
          io << script.to_before_script
        end
        File.open(fixture_path("integration/ruby/matrix/1.after_script.sh"), 'w') do |io|
          io << script.to_after_script
        end
        File.open(fixture_path("integration/ruby/matrix/1.script.sh"), 'w') do |io|
          io << script.to_script
        end
=end
      end

      it { should_not be_deploy }
      its(:to_before_script) { should eq fixture("integration/ruby/matrix/1.before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/matrix/1.script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/matrix/1.after_script.sh") }
    end

    context "deploy configuration" do
      let(:task)   { create :task, deploy: true }
      let(:source) { matrix.deploy_configuration("master") }
      subject { script }

      before do
=begin
        File.open(fixture_path("integration/ruby/matrix/d.before_script.sh"), 'w') do |io|
          io << script.to_before_script
        end
        File.open(fixture_path("integration/ruby/matrix/d.after_script.sh"), 'w') do |io|
          io << script.to_after_script
        end
        File.open(fixture_path("integration/ruby/matrix/d.script.sh"), 'w') do |io|
          io << script.to_script
        end
=end
      end

      it "should have source" do
        expect(source).to be
      end

      it { should be_deploy }
      its(:to_before_script) { should eq fixture("integration/ruby/matrix/d.before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/matrix/d.script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/matrix/d.after_script.sh") }

    end
  end
end
