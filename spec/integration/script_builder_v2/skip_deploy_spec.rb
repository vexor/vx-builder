require 'spec_helper'
require 'yaml'
require 'tmpdir'
require 'fileutils'

describe "(integration v2) Skips" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end
  after { FileUtils.rm_rf(path) }

  def build_deploy(file, options = {})
    source = YAML.load fixture(file)
    to_build_configuration = ::Vx::Builder::BuildConfiguration.new(source)
    to_matrix = ::Vx::Builder.matrix(to_build_configuration)
    ::Vx::Builder.deploy(to_matrix, options)
  end

  it "should generate valid yaml" do
    file = "extended_travis.yml"
    options = {sha: "HEAD", branch: "ci"}
    deploy = build_deploy(file, options)
    config = deploy.build.first
    script = Vx::Builder.script_v2(create(:task), config)
    res_yaml = script.to_yaml
    # puts res_yaml
    expect(res_yaml).to match(/Skipped/)
  end

end
