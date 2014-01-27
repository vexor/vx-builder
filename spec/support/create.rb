require 'ostruct'

def create(name, options = {})
  case name
  when :message
    Vx::Message::PerformBuild.test_message

  when :task
    msg = create(:message)
    Vx::Builder::Task.new(
      'name',
      msg.src,
      msg.sha,
      deploy_key: msg.deploy_key,
      branch:     msg.branch
    )

  when :source
    Vx::Builder::Source.from_yaml(fixture("travis.yml"))

  when :env
    OpenStruct.new(
      init:   [],
      source: create(:source),
      task:   create(:task)
    )

  when :command_from_env
    env = options[:env]
    a = ["set -e"]
    a += env.init
    a.join("\n")
  end
end
