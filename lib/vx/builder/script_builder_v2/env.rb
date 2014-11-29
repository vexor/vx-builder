module Vx
  module Builder
    class ScriptBuilderV2

      class Env < Base

        def call(env)
          env.stage("init").tap do |e|
            e.add_env "CI",                 "1"
            e.add_env "CI_JOB_ID",          env.task.job_id
            e.add_env "CI_JOB_NUMBER",      env.task.job_number
            e.add_env "CI_BUILD_ID",        env.task.build_id
            e.add_env "CI_BUILD_NUMBER",    env.task.build_number
            e.add_env "CI_PROJECT_NAME",    env.task.name
            e.add_env "CI_BUILD_SHA",       env.task.sha

            if env.task.project_token
              e.add_env "CI_PROJECT_TOKEN", env.task.project_token, hidden: true
            end

            if env.task.pull_request_id
              e.add_env "CI_PULL_REQUEST_ID", env.task.pull_request_id
            end

            if env.task.branch
              e.add_env "CI_BRANCH", env.task.branch
            end

            e.add_env "DISPLAY", ":99"

            if env.source.parallel?
              e.add_env "CI_PARALLEL_JOBS", env.source.parallel
              e.add_env "CI_PARALLEL_JOB_NUMBER", env.source.parallel_job_number
            end

            env.source.env.global.each do |i|
              i = i.split("=")
              key = i.shift
              value = i.join("=").to_s
              e.add_env key, normalize_env_value(value)
            end

            env.source.env.matrix.each do |i|
              i = i.split("=")
              key = i.shift
              value = i.join("=").to_s
              e.add_env key, normalize_env_value(value)
            end
          end

          app.call(env)
        end

        def normalize_env_value(value)
          if value[0] == '"' && value[-1] == '"'
            value[1..-2]
          else
            value
          end
        end

      end
    end
  end
end
