module Vx
  module Builder
    class Script

      Scala = Struct.new(:app) do

        include Helper::TraceShCommand

        DEFAULT_SCALA = '2.10.3'

        def call(env)
          if enabled?(env)
            env.cache_key << "scala-#{scala env}"

            env.announce.tap do |i|
              i << "echo Using scala #{scala env}"
            end

            if env.source.script.empty?
              env.script.tap do |i|
                i << "if [[ -d project || -f build.sbt ]] ; then #{trace_sh_command "sbt ++#{scala env} test"} ; fi"
              end
            end

            if env.source.cached_directories != false
              env.cached_directories.push "~/.sbt"
              env.cached_directories.push "~/.ivy2"
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.scala.first || env.language == 'scala'
          end

          def scala(env)
            env.source.scala.first || DEFAULT_SCALA
          end


      end
    end
  end
end
