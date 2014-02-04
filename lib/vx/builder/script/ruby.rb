module Vx
  module Builder
    class Script

      Ruby = Struct.new(:app) do

        include Helper::TraceShCommand

        def call(env)
          if rvm env
            env.cache_key << "rvm-#{rvm env}"

            env.before_install.tap do |i|
              i << 'eval "$(rbenv init -)" || true'
              i << "rbenv shell #{make_rbenv_version_command env}"
              i << "export BUNDLE_GEMFILE=${PWD}/#{gemfile(env)}"
              i << 'export GEM_HOME=$HOME/cached/rubygems'
            end

            env.announce.tap do |a|
              a << trace_sh_command("ruby --version")
              a << trace_sh_command("gem --version")
              a << trace_sh_command("bundle --version")
            end

            env.install.tap do |i|
              i << trace_sh_command("bundle install")
              i << trace_sh_command("bundle clean --force")
            end
          end

          app.call(env)
        end

        private

          def rvm(env)
            env.source.rvm.first
          end

          def gemfile(env)
            env.source.gemfile.first || "Gemfile"
          end

          def make_rbenv_version_command(env)
            select_rbenv_version(env)
          end

          def select_rbenv_version(env)
            %{
              $(rbenv versions |
                sed -e 's/^\*/ /' |
                awk '{print $1}' |
                grep -v 'system' |
                grep '#{rvm env}' |
                tail -n1)
            }.gsub(/\n/, ' ').gsub(/ +/, ' ').strip
          end

      end
    end
  end
end
