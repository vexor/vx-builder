module Vx
  module Builder
    class ScriptBuilder

      class Rust < Base

        DEFAULT_RUST = '0.11.0'

        def call(env)
          if enabled?(env)

            vxvm_install(env, 'rust', rust_version(env))

            do_cache_key(env) do |i|
              i << "rust-#{rust_version env}"
            end

            do_install(env) do |i|
              i << trace_sh_command("git submodule init")
              i << trace_sh_command("git submodule update")
            end

            do_announce(env) do |i|
              i << trace_sh_command("rustc --version")
            end

            do_script(env) do |i|
              i << trace_sh_command("if [ -f Makefile ] ; then make ; fi", trace: "make")
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
