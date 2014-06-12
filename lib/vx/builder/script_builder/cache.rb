module Vx
  module Builder
    class ScriptBuilder

      Cache = Struct.new(:app) do

        include Helper::Config

        CASHER_URL = "https://raw2.github.com/dima-exe/casher/master/bin/casher"
        CASHER_BIN = "$HOME/.casher/bin/casher"

        def call(env)
          rs = app.call env

          if env.task.cache_url_prefix && enabled?(env)
            assign_url_to_env(env)
            prepare(env)
            fetch(env)
            add(env)
            push(env)
          end

          rs
        end

        private

          def enabled?(env)
            !env.cached_directories.empty?
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
