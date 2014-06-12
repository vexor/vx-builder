require 'ostruct'

def create(name, options = {})
  case name
  when :message
    Vx::Message::PerformBuild.test_message

  when :task
    msg = create(:message)
    Vx::Builder::Task.new(
      job_id:           1,
      build_id:         12,
      name:             'name',
      src:              msg.src,
      sha:              msg.sha,
      deploy_key:       msg.deploy_key,
      branch:           msg.branch,
      cache_url_prefix: "http://example.com",
      pull_request_id:  options[:pull_request_id]
    )

  when :source
    name = options[:name] || "travis.yml"
    Vx::Builder::BuildConfiguration.from_yaml(fixture(name))

  when :env
    OpenStruct.new(
      init:           [],
      before_install: [],
      install:        [],
      announce:       [],
      before_script:  [],
      script:         [],
      after_script:   [],
      after_script_init: [],
      source:         options[:source] || create(:source),
      after_success:  [],
      task:           options[:task] || create(:task),
      cache_key:      [],
      cached_directories: [],
      before_deploy:       [],
      deploy:              [],
    )

  when :command_from_env
    env = options[:env]
    a = ["set -e"]
    a += env.init
    a.join("\n")

  when :build_configuration_with_matrix_values
    attributes = {
      "env"            => %w{ FOO=1 BAR=2 },
      "rvm"            => %w{ 1.8.7 1.9.3 2.0.0 },
      "scala"          => %w{ 2.9.2 2.10.1 },
      "before_script"  => "echo before_script",
      "before_install" => "echo before_install",
      "script"         => "echo script",
    }.merge(options)
    Vx::Builder::BuildConfiguration.new attributes

  when :matrix_builder
    Vx::Builder::MatrixBuilder.new create(:build_configuration_with_matrix_values, options)
  end

end
