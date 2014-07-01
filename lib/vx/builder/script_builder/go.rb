module Vx
  module Builder
    class ScriptBuilder

      class Go < Base

        DEFAULT_GO = '1.2'

        def call(env)
          if enabled?(env)
            do_before_install(env) do |i|

              vxvm_install = "vxvm install go #{go_version env}"
              i << trace_sh_command(vxvm_install)
              i << %{VX_VM_EVAL="$(#{vxvm_install}"}
              i << %{eval "$VX_VM_EVAL"}

              i << trace_sh_command('export GOPATH=$VX_ROOT/gopath')
              i << trace_sh_command('export PATH=$GOPATH/bin:$PATH')
              i << trace_sh_command('export VX_ORIG_CODE_ROOT=$(pwd)')
              i << trace_sh_command('export VX_NEW_CODE_ROOT=$GOPATH/src/vexor.io/$CI_PROJECT_NAME')

              i << trace_sh_command('mkdir -p $VX_NEW_CODE_ROOT')
              i << trace_sh_command('rmdir $VX_NEW_CODE_ROOT')
              i << trace_sh_command('mv $VX_ORIG_CODE_ROOT $VX_NEW_CODE_ROOT')
              i << trace_sh_command('ln -s $VX_NEW_CODE_ROOT $VX_ORIG_CODE_ROOT')
              i << trace_sh_command('cd $VX_NEW_CODE_ROOT')
            end

            do_announce(env) do |i|
              i << trace_sh_command("go version")
            end

            do_install(env) do |i|
              i << trace_sh_command("go get -t")
            end

            do_script(env) do |i|
              i << trace_sh_command("go test")
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.go.first || env.source.language == 'go'
          end

          def go_version(env)
            env.source.go.first || DEFAULT_GO
          end

      end
    end
  end
end
