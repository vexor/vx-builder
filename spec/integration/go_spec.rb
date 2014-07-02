require 'spec_helper'
require 'yaml'
require 'tmpdir'
require 'fileutils'

describe "(integration) go" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end
  after { FileUtils.rm_rf(path) }

  def write_script_to_filter(prefix, script)
=begin
    File.open(fixture_path("integration/go/#{prefix}before_script.sh"), 'w') do |io|
      io << script.to_before_script
    end
    File.open(fixture_path("integration/go/#{prefix}after_script.sh"), 'w') do |io|
      io << script.to_after_script
    end
    File.open(fixture_path("integration/go/#{prefix}script.sh"), 'w') do |io|
      io << script.to_script
    end
=end
  end

  def build(file, options = {})
    config = Vx::Builder::BuildConfiguration.from_yaml(file)
    matrix = Vx::Builder.matrix config
    options[:task] ||= create(:task)
    script = Vx::Builder.script(options[:task], matrix.build.first)
    OpenStruct.new script: script, matrix: matrix
  end

  context "(generation)" do
    let(:file) { fixture("integration/go/language/config.yml") }
    let(:b)    { build(file) }
    before { write_script_to_filter "language/", b.script }

    it "should generate one configuration" do
      expect(b.matrix.build).to have(1).item
    end

    it "should generate valid scripts" do
      expect(b.script.to_before_script).to eq fixture("integration/go/language/before_script.sh")
      expect(b.script.to_script).to eq fixture("integration/go/language/script.sh")
      expect(b.script.to_after_script).to eq fixture("integration/go/language/after_script.sh")
    end
  end

  it "should succesfuly run lang/go", real: true do
    file = {"language" => "go"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/go"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.script.to_before_script
        io.write b.script.to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end
end
