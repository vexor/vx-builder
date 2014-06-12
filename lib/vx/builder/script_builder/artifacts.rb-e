module Vx
  module Builder
    class Script

      class Artifacts < Base

        FIND='find . -type f -path "./%s" | sed "s/^\.\///g"'

        def call(env)
          rs = app.call env

          if enabled?(env)
            env.after_script << "echo"
            env.source.artifacts.files.map{|a| compile(a) }.each do |artifact|
              find = FIND % artifact
              url = env.task.artifacts_url_prefix
              prefix = env.source.artifacts.prefix
              name = prefix ? "#{prefix}$i" : "$i"
              cmd = %{
                for i in $(#{find}) ; do
                  echo "upload artifact #{name}"
                  curl -s -S -X PUT -T $i #{url}/#{name} > /dev/null
                done
              }
              env.after_script << cmd
            end
            env.after_script << "echo"
          end

          rs
        end

        private

          def compile(artifact)
            case
            when artifact.end_with?("/")
              "#{artifact}*"
            else
              artifact
            end
          end

          def enabled?(env)
            !env.source.artifacts.files.empty? &&
              env.task.artifacts_url_prefix
          end

          def casher_cmd
            "test -f #{CASHER_BIN} && #{config.casher_ruby} #{CASHER_BIN}"
          end

          def assign_url_to_env(env)
            urls   = []
            branch = env.task.branch
            if branch != 'master'
              urls << url_for(env, branch)
            end
            urls << url_for(env, 'master')

            env.cache_fetch_url = urls
            env.cache_push_url  = url_for(env, branch)
            env
          end

          def url_for(env, branch)
            name = branch

            key =
              if env.cache_key.empty?
                "cache"
              else
                env.cache_key.join("-").downcase.gsub(/[^a-z0-9_\-.]/, '-')
              end

            "#{env.task.cache_url_prefix}/#{name}/#{key}.tgz"
          end

          def prepare(env)
            cmd = %{
              export CASHER_DIR=$HOME/.casher &&
              ( mkdir -p $CASHER_DIR/bin &&
                /usr/bin/curl #{CASHER_URL} -s -o #{CASHER_BIN} &&
                chmod +x #{CASHER_BIN} ) ||
              true
            }.gsub(/\n/, ' ').gsub(/ +/, ' ')
            env.init << cmd
          end

          def fetch(env)
            urls = env.cache_fetch_url.join(" ")
            env.init << "#{casher_cmd} fetch #{urls} || true"
          end

          def add(env)
            env.cached_directories.each do |d|
              env.init << "#{casher_cmd} add #{d} || true"
            end
            env.init << "unset CASHER_DIR"
          end

          def push(env)
            if env.cache_push_url
              env.after_script << "#{casher_cmd} push #{env.cache_push_url}"
            end
          end

      end
    end
  end
end
