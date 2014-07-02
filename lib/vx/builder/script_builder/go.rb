module Vx
  module Builder
    class ScriptBuilder

      class Go < Base

        DEFAULT_GO = '1.2'

        def call(env)
          if enabled?(env)
            do_before_install(env) do |i|

              vxvm_install = "sudo vxvm install go #{go_version env}"
              i << trace_sh_command(%{VX_VM_SOURCE="$(#{vxvm_install})"}, trace: vxvm_install)
              i << %{source "$VX_VM_SOURCE"}

              i << trace_sh_command('export VX_GOPATH=$VX_ROOT/gopath:$GOPATH')
              i << trace_sh_command('export PATH=$VX_GOPATH/bin:$PATH')
              i << trace_sh_command('export VX_ORIG_CODE_ROOT=$(pwd)')
              i << trace_sh_command("export VX_NEW_CODE_ROOT=$VX_GOPATH/src/#{project_path env}")

              i << trace_sh_command('mkdir -p $VX_NEW_CODE_ROOT')
              i << trace_sh_command('rmdir $VX_NEW_CODE_ROOT')
              i << trace_sh_command('mv $VX_ORIG_CODE_ROOT $VX_NEW_CODE_ROOT')
              i << trace_sh_command('ln -s $VX_NEW_CODE_ROOT $VX_ORIG_CODE_ROOT')
              i << trace_sh_command('cd $VX_NEW_CODE_ROOT')
            end

            do_announce(env) do |i|
              i << trace_sh_command("go version")
              i << trace_sh_command("go env")
            end

            do_install(env) do |i|
              i << trace_sh_command("go get -v ./...")
            end

            do_script(env) do |i|
              i << trace_sh_command("go test -v ./...")
            end
          end

          app.call(env)
        end

        private

          def project_path(env)
            "#{env.task.project_host}/#{env.task.name}"
          end

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
