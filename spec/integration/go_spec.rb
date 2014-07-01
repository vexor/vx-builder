require 'spec_helper'

describe "(integration) go" do
  let(:build_configuration) {
    Vx::Builder::BuildConfiguration.from_yaml(config)
  }
  let(:matrix) { Vx::Builder.matrix build_configuration }
  let(:task)   { create :task }
  let(:script) { Vx::Builder.script(task, source) }
  subject { matrix }

  def write_script_to_filter(prefix)
    File.open(fixture_path("integration/go/#{prefix}before_script.sh"), 'w') do |io|
      io << script.to_before_script
    end
    File.open(fixture_path("integration/go/#{prefix}after_script.sh"), 'w') do |io|
      io << script.to_after_script
    end
    File.open(fixture_path("integration/go/#{prefix}script.sh"), 'w') do |io|
      io << script.to_script
    end
  end

  context "language" do
    let(:config) { fixture("integration/go/language/config.yml") }
    let(:source) { matrix.build.first }

    before { write_script_to_filter "language/" }

    it "should generate one configuration" do
      expect(matrix.build).to have(1).item
    end

    it "should generate valid scripts" do
      expect(script.to_before_script).to eq fixture("integration/go/language/before_script.sh")
      expect(script.to_script).to eq fixture("integration/go/language/script.sh")
      expect(script.to_after_script).to eq fixture("integration/go/language/after_script.sh")
    end
  end
end
