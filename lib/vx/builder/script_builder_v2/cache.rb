module Vx
  module Builder
    class ScriptBuilderV2

      class Cache < Base

        include Helper::Config

        def call(env)
          rs = app.call env

          if env.task.cache_url_prefix && enabled?(env)
            env.stage("init").add_task "cache_fetch",    "url" => cache_fetch_urls(env)
            env.stage("init").add_task "cache_add",      "dir" => cache_directories(env)
            env.stage("teardown").add_task "cache_push", "url" => cache_push_url(env)
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
            url_for(env, env.task.branch)
          end

          def cache_fetch_urls(env)
            urls   = []
            branch = env.task.branch
            if branch != 'master'
              urls << url_for(env, branch)
            end
            urls << url_for(env, 'master')

            urls
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

      end
    end
  end
end
