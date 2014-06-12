module Vx
  module Builder
    class ScriptBuilder

      class Scala < Base

        DEFAULT_SCALA = '2.10.3'

        def call(env)
          if enabled?(env)
            do_cache_key(env) do |i|
              i << "scala-#{scala env}"
            end

            do_announce(env) do |i|
              i << trace_sh_command("export SCALA_VERSION=#{scala env}")
            end

            do_install(env) do |i|
              i << "if [[ -d project || -f build.sbt ]] ; then #{trace_sh_command "sbt ++#{scala env} update"} ; fi"
            end

            do_script(env) do |i|
              i << "if [[ -d project || -f build.sbt ]] ; then #{trace_sh_command "sbt ++#{scala env} test"} ; fi"
            end

            do_cached_directories(env) do |i|
              i << "~/.sbt"
              i << "~/.ivy2"
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.scala.first || env.source.language == 'scala'
          end

          def scala(env)
            env.source.scala.first || DEFAULT_SCALA
          end


      end
    end
  end
end
