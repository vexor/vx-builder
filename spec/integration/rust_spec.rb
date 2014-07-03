require 'spec_helper'
require 'yaml'
require 'tmpdir'
require 'fileutils'

describe "(integration) rust" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end
  after { FileUtils.rm_rf(path) }

  def build(file, options = {})
    config = Vx::Builder::BuildConfiguration.from_yaml(file)
    matrix = Vx::Builder.matrix config
    options[:task] ||= create(:task)
    script = Vx::Builder.script(options[:task], matrix.build.first)
    OpenStruct.new script: script, matrix: matrix
  end

  it "should succesfuly run lang/rust", real: true do
    file = {"language" => "rust"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/rust"
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
