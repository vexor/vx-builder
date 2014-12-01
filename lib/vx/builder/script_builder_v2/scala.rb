module Vx
  module Builder
    class ScriptBuilderV2

      class Scala < Base

        DEFAULT_SCALA = '2.10.3'

        def call(env)
          if enabled?(env)
            do_cache_key(env) do |i|
              i << "scala-#{scala env}"
            end

            do_cached_directories(env) do |i|
              i << "~/.sbt"
              i << "~/.ivy2"
            end

            env.stage("install").tap do |i|
              i.add_task 'scala', 'action' => 'install', 'scala' => scala(env)
              do_install(env) do
                i.add_task 'scala', "sbt:update"
              end
            end

            do_script(env) do
              env.stage("script").tap do |i|
                i.add_task 'scala', 'sbt:test'
              end
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
