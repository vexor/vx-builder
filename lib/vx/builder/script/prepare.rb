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

          repo_path    = "${VX_ROOT}/code/#{name}"
          data_path    = "${VX_ROOT}/data/#{name}"
          key_file     = "#{data_path}/key"
          git_ssh_file = "#{data_path}/git_ssh"

          sha          = env.task.sha
          scm          = build_scm(env, sha, repo_path)
          git_ssh      = scm.git_ssh_content(deploy_key && "#{key_file}")

          env.init.tap do |i|
            i << 'export VX_ROOT=$(pwd)'

            i << "mkdir -p #{data_path}"
            i << "mkdir -p #{repo_path}"

            if deploy_key
              i << upload_sh_command(key_file, deploy_key)
              i << "chmod 0600 #{key_file}"
              i << "export VX_PRIVATE_KEY=#{key_file}"
            end

            i << upload_sh_command(git_ssh_file, git_ssh)
            i << "chmod 0750 #{git_ssh_file}"

            i << "export GIT_SSH=#{git_ssh_file}"
            i << scm.fetch_cmd
            i << "unset GIT_SSH"

            i << 'echo "Starting SSH Agent"'
            i << 'eval "$(ssh-agent)"'
            i << "ssh-add $VX_PRIVATE_KEY"

            i << "cd #{repo_path}"
          end

          env.after_script_init.tap do |i|
            i << 'export VX_ROOT=$(pwd)'
            i << "cd #{repo_path}"
          end

          app.call env
        end

        private

          def build_scm(env, sha, path)
            Common::Git.new(env.task.src,
                         sha,
                         path,
                         branch: env.task.branch,
                         pull_request_id: env.task.pull_request_id)
          end

      end
    end
  end
end
