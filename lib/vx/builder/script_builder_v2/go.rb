module Vx
  module Builder
    class ScriptBuilderV2

      class Go < Base

        DEFAULT_GO = '1.2'

        def call(env)
          if enabled?(env)

            do_install(env) do
              env.stage("before_install").tap do |i|
                i.add_task "vxvm", "go #{go_version(env)}"
              end
            end

            env.stage("install").tap do |i|
              i.add_env 'GOPATH', '${HOME}/gopath:${GOPATH}'
              i.add_env 'PATH',   '${HOME}/gopath/bin:${PATH}'
              i.add_env 'VX_ORIG_CODE_ROOT', '${PWD}'
              i.add_env "VX_NEW_CODE_ROOT",  "${HOME}/gopath/src/#{project_path env}"

              i.add_task 'shell', 'mkdir -p $VX_NEW_CODE_ROOT'
              i.add_task 'shell', 'rmdir $VX_NEW_CODE_ROOT'
              i.add_task 'shell', 'cp -r $VX_ORIG_CODE_ROOT $VX_NEW_CODE_ROOT'
              i.add_task 'shell', "sudo chown -R ${USER}:${USER} ${GOROOT}"
              i.add_task 'chdir', '${VX_NEW_CODE_ROOT}'

              i.add_task 'shell', 'go version'
              i.add_task 'shell', 'go env'

              do_install(env) do
                i.add_task 'shell', 'go get -v ./...'
              end
            end

            do_script(env) do
              env.stage("script").tap do |i|
                i.add_task 'shell', 'go test -v ./...'
              end
            end

          end

          app.call(env)
        end

        private

          def project_path(env)
            "#{env.task.project_host}/#{env.task.name}"
          end

          def enabled?(env)
            env.source.language == 'go'
          end

          def go_version(env)
            env.source.go.first || DEFAULT_GO
          end

      end
    end
  end
end
