module Vx
  module Builder
    class ScriptBuilderV2

      class Python < Base

        DEFAULT_PYTHON = '2.7'
        PIP_DOWNLOADS = "~/.pip-downloads"
        PIP_OPTS = " --download-cache=#{PIP_DOWNLOADS}"

        def call(env)
          if enabled?(env)

            py_version = python_version(env)

            do_cache_key(env) do |i|
              i << "python-#{py_version}"
            end

            do_cached_directories(env) do |i|
              i << PIP_DOWNLOADS
            end

            env.stage("init").tap do |i|
              i.add_env 'TRAVIS_PYTHON_VERSION', "py_version"
            end

            env.stage("install").tap do |i|
              i.add_task "python", "action" => "install", "python" => DEFAULT_PYTHON
              i.add_task "python", "virtualenv"
              i.add_task "python", "announce"

              do_install(env) do
                pip_args = PIP_OPTS
                if args = env.source.pip_args.first
                  pip_args = args
                end
                i.add_task "python", "action" => "pip:install", "pip_args" => pip_args
              end
            end

            do_before_script(env) do
              env.stage("before_script").tap do |i|
                i.add_task "python", "django:settings"
              end
            end

            do_script(env) do
              env.stage("script").tap do |i|
                i.add_task "python", "script"
              end
            end

          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.python.first || env.source.language == 'python'
          end

          def python_version(env)
            v = env.source.python.first
            v || DEFAULT_PYTHON
          end

      end
    end
  end
end
