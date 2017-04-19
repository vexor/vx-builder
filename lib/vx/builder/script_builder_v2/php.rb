module Vx
  module Builder
    class ScriptBuilderV2
      class Php < Base

        DEFAULT_VERSION = '7.1'
        PHP_VENDOR = "vendor"

        def call(env)
          if enabled?(env)
            php_version = get_php_version(env)

            do_cache_key(env) do |i|
              i << "php-#{php_version}"
              i << "composer"
            end

            do_cached_directories(env) do |i|
              i << PHP_VENDOR
            end

            env.stage("install").tap do |i|
              i.add_task "vxvm", "php #{php_version}"
              i.add_task 'shell', 'php --version'
              i.add_task 'shell', 'composer --version'

              do_install(env) do
              end
            end

            do_script(env) do
            end
          end

          app.call(env)
        end

        private

        def enabled?(env)
          env.source.php.first || env.source.language == 'php'
        end

        def get_php_version(env)
          env.source.php.first || DEFAULT_VERSION
        end

      end
    end
  end
end
