module Vx
  module Builder
    class Script

      Clojure = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          if enabled?(env)
            env.announce.tap do |i|
              i << trace_sh_command("lein version")
            end

            env.install.tap do |i|
              i << "lein deps"
            end

            if env.source.script.empty?
              env.script.tap do |i|
                i << "lein test"
              end
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.language == 'clojure'
          end

      end
    end
  end
end
