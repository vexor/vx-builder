module Vx
  module Builder
    class ScriptBuilderV2

      class Rust < Base

        DEFAULT_RUST = '0.11.0'

        def call(env)
          if enabled?(env)

            do_cache_key(env) do |i|
              i << "rust-#{rust_version env}"
            end

            env.stage("install").tap do |i|
              i.add_task "vxvm", "rust #{rust_version(env)}"
              i.add_task "shell", "rustc --version"

              do_install(env) do
                i.add_task "shell", "git submodule init"
                i.add_task "shell", "git submodule update"
              end
            end

            do_script(env) do
              env.stage("script").tap do |i|
                i.add_task "shell", "make"
              end
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.rust.first || env.source.language == 'rust'
          end

          def rust_version(env)
            env.source.rust.first || DEFAULT_RUST
          end

      end
    end
  end
end
