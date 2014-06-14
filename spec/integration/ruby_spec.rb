require 'spec_helper'

describe "(integration) ruby" do
  let(:build_configuration) {
    Vx::Builder::BuildConfiguration.from_yaml(config)
  }
  let(:matrix) { Vx::Builder.matrix build_configuration }
  let(:task)   { create :task }
  let(:script) { Vx::Builder.script(task, source) }
  subject { matrix }

  def write_script_to_filter(prefix)
=begin
    File.open(fixture_path("integration/ruby/#{prefix}before_script.sh"), 'w') do |io|
      io << script.to_before_script
    end
    File.open(fixture_path("integration/ruby/#{prefix}after_script.sh"), 'w') do |io|
      io << script.to_after_script
    end
    File.open(fixture_path("integration/ruby/#{prefix}script.sh"), 'w') do |io|
      io << script.to_script
    end
=end
  end

  context "language" do
    let(:config) { fixture("integration/ruby/language/config.yml") }

    its(:build) { should have(1).item }

    context "first configuration" do
      let(:source) { matrix.build.first }
      subject { script }

      before { write_script_to_filter "language/" }

      its(:to_before_script) { should eq fixture("integration/ruby/language/before_script.sh") }
      its(:to_script)        { should eq fixture("integration/ruby/language/script.sh") }
      its(:to_after_script)  { should eq fixture("integration/ruby/language/after_script.sh") }
    end
  end

  context "deploy" do
    let(:config) { fixture("integration/ruby/deploy/config.yml") }

    context "configuration" do
      let(:task)    { create :task, deploy: true }
      let(:sources) { Vx::Builder.deploy(matrix, branch: "master").build }

      it "should have source" do
        expect(sources).to have(1).item
      end

      context "first deploy configuration" do
        let(:source) { sources.first }
        before { write_script_to_filter "deploy/d." }
        subject { script }

        its(:to_before_script) { should eq fixture("integration/ruby/deploy/d.before_script.sh") }
        its(:to_script)        { should eq fixture("integration/ruby/deploy/d.script.sh") }
        its(:to_after_script)  { should eq fixture("integration/ruby/deploy/d.after_script.sh") }
      end
    end
  end

  context "matrix" do
    let(:config) { fixture("integration/ruby/matrix/config.yml") }

    its(:build) { should have(2).item }

    context "0th configuration" do
      let(:source) { matrix.build[0] }
      subject { script }

      before { write_script_to_filter "matrix/0." }

      its(:to_before_script) { should eq fixture("integration/ruby/matrix/0.before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/matrix/0.script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/matrix/0.after_script.sh") }
    end

    context "1th configuration" do
      let(:source) { matrix.build[1] }
      subject { script }

      before { write_script_to_filter "matrix/1." }

      its(:to_before_script) { should eq fixture("integration/ruby/matrix/1.before_script.sh") }
      its(:to_script) { should eq fixture("integration/ruby/matrix/1.script.sh") }
      its(:to_after_script) { should eq fixture("integration/ruby/matrix/1.after_script.sh") }
    end

    context "deploy configuration" do
      let(:task)    { create :task }
      let(:sources) { Vx::Builder.deploy(matrix, branch: "master").build }

      it "should have source" do
        expect(sources).to have(1).item
      end

      context "first deploy configuration" do
        let(:source) { sources.first }
        subject { script }
        before { write_script_to_filter "matrix/d." }

        its(:to_before_script) { should eq fixture("integration/ruby/matrix/d.before_script.sh") }
        its(:to_script) { should eq fixture("integration/ruby/matrix/d.script.sh") }
        its(:to_after_script) { should eq fixture("integration/ruby/matrix/d.after_script.sh") }
      end
    end
  end
end
