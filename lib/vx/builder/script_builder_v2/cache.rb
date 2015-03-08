module Vx
  module Builder
    class ScriptBuilderV2

      class Cache < Base

        include Helper::Config

        def call(env)
          rs = app.call env

          if env.task.cache_read_url && env.task.cache_write_url && enabled?(env)
            env.stage("init").add_task     "cache_fetch", "url" => cache_fetch_urls(env)
            env.stage("init").add_task     "cache_add",   "dir" => cache_directories(env)
            env.stage("teardown").add_task "cache_push",  "url" => cache_push_url(env)
          end

          rs
        end

        private

          def enabled?(env)
            env.source.cache.enabled? && cache_directories(env).any?
          end

          def cache_directories(env)
            env.source.cache.directories
          end

          def cache_push_url(env)
            url_for(env, env.task.branch, 'w')
          end

          def cache_fetch_urls(env)
            urls   = []
            branch = env.task.branch
            if branch != 'master'
              urls << url_for(env, branch, 'r')
            end
            urls << url_for(env, 'master', 'r')

            urls
          end

          def url_for(env, branch, mode)
            name = branch

            key =
              if env.cache_key.empty?
                "cache"
              else
                env.cache_key.join("-").downcase.gsub(/[^a-z0-9_\-.]/, '-')
              end

            prefix =
              case mode
              when 'r'
                env.task.cache_read_url
              when 'w'
                env.task.cache_write_url
              end

            "#{prefix}?file_name=#{name}/#{key}.tgz"
          end

      end
    end
  end
end
