require 'vx/common'

module Vx
  module Builder
    class Script

      Prepare = Struct.new(:app) do

        include Helper::TraceShCommand
        include Common::Helper::UploadShCommand

        def call(env)
          name         = env.task.name
          deploy_key   = env.task.deploy_key

          repo_path    = "code/#{name}"
          data_path    = "data/#{name}"
          key_file     = "#{data_path}/key"
          git_ssh_file = "#{data_path}/git_ssh"

          sha          = env.task.sha
          scm          = build_scm(env, sha, repo_path)
          git_ssh      = scm.git_ssh.class.template(deploy_key && "$(dirname $0)/key")

          env.init.tap do |i|
            i << "mkdir -p  #{data_path}"
            i << "mkdir -p  #{repo_path}"

            if deploy_key
              i << "echo instaling keys"
              i << upload_sh_command(key_file, deploy_key)
              i << "chmod 0600 #{key_file}"
            end

            i << upload_sh_command(git_ssh_file, git_ssh)
            i << "chmod 0750 #{git_ssh_file}"

            i << "export GIT_SSH=$PWD/#{git_ssh_file}"
            i << scm.make_fetch_command
            i << "unset GIT_SSH"
          end

          app.call env
        end

        private

          def build_scm(env, sha, path)
            SCM::Git.new(env.task.src,
                         sha,
                         "$PWD/#{path}",
                         branch: env.task.branch,
                         pull_request_id: env.task.pull_request_id)
          end

      end
    end
  end
end
