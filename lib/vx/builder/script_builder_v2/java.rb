module Vx
  module Builder
    class ScriptBuilderV2

      class Java < Base

        def call(env)
          if version = java(env)
            do_cache_key(env) do |i|
              i << "jdk-#{version}"
            end

            env.stage("install").tap do |i|
              i.add_task "jdk",  "action" => "install", "version" => version
            end
=begin
            env.stage("before_install").tap do |i|
            end

            do_before_install(env) do |i|
              i << "source $(which jdk_switcher.sh)"
              i << trace_sh_command("jdk_switcher use #{java env}")
            end
=end
          end

          app.call(env)
        end

        private

          def java(env)
            env.source.jdk.first
          end

      end
    end
  end
end
