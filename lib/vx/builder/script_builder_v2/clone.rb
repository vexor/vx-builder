require 'vx/common'

module Vx
  module Builder
    class ScriptBuilderV2

      Clone = Struct.new(:app) do

        def call(env)

          env.stage("clone").tap do |e|
            e.add_task "ssh_agent", "key" => env.task.ssh_keys

            clone = {}
            clone["repo"] = env.task.src
            clone["dest"] = "~/#{env.task.name}"
            clone["branch"] = branch_name(env)
            clone["sha"] = env.task.sha
            if pr = env.task.pull_request_id
              clone["pr"] = pr
            end
            e.add_task "git_clone", clone
          end

          chdir!(env)

          app.call(env)
        end

        private

          def chdir!(env)
            repo, workdir = "~/#{env.task.name}", env.source.workdir
            env.stage("init").chdir!("#{repo}#{workdir}")
          end

          def branch_name(env)
            b = env.task && env.task.branch
            if b && b != 'HEAD'
              b
            end
          end

      end
    end
  end
end
