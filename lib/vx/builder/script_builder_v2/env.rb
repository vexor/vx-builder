require 'shellwords'

module Vx
  module Builder
    class ScriptBuilderV2

      class Env < Base

        def call(env)
          env.stage("init").tap do |e|
            e.add_env "CI_NAME",            "VEXOR"
            e.add_env "CI",                 "1"
            e.add_env "CI_JOB_ID",          env.task.job_id
            e.add_env "CI_JOB_NUMBER",      env.task.job_number
            e.add_env "CI_BUILD_ID",        env.task.build_id
            e.add_env "CI_BUILD_URL",       env.task.build_url
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

            if env.task.files
              e.add_env "CI_CHANGED_FILES", Array(env.task.files.map{ |s| Shellwords.shellescape(s) }).join(" ")
            end

            e.add_env "DISPLAY", ":99"

            env.task.tap do |t|
              t.env_vars.each do |key, value|
                e.add_env key, Shellwords.escape(value), hidden: true
              end
            end


            if env.source.parallel?
              e.add_env "CI_PARALLEL_JOBS", env.source.parallel
              e.add_env "CI_PARALLEL_JOB_NUMBER", env.source.parallel_job_number
            end

          end

          app.call(env)
        end
      end
    end
  end
end
