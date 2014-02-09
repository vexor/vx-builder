module Vx
  module Builder
    class Script

      Env = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          env.init << "set -e"
          env.init << "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          env.init << 'export LC_ALL=en_US.UTF8'
          env.init << "for i in $(ls /etc/profile.d) ; do source /etc/profile.d/$i ; done"

          if b = env.task.branch
            env.init << "export CI_BRANCH=#{b}"
          end

          env.source.global_env.each do |e|
            env.init << trace_sh_command("export #{e}")
          end
          app.call(env)
        end

      end
    end
  end
end
