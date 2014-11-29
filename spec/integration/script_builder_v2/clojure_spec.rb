require 'spec_helper'
require 'yaml'
require 'tmpdir'
require 'fileutils'

describe "(integration v2) go" do
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
    script = Vx::Builder.script_v2(options[:task], matrix.build.first)
    OpenStruct.new script: script, matrix: matrix
  end

  it "should succesfuly run lang/clojure", real: true do
    file = {"language" => "clojure"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/clojure"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.script.to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end
end
