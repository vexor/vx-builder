module Vx
  module Builder
    class Script

      Ruby = Struct.new(:app) do

        include Helper::TraceShCommand

        DEFAULT_RUBY = '1.9.3'

        def call(env)
          if enabled?(env)
            env.cache_key << "rvm-#{ruby env}"
            env.cache_key << gemfile(env)

            env.before_install.tap do |i|
              i << 'eval "$(rbenv init -)" || true'
              i << "rbenv shell #{make_rbenv_version_command env}"
              i << trace_sh_command("export BUNDLE_GEMFILE=${PWD}/#{gemfile(env)}")
              i << trace_sh_command('export GEM_HOME=~/.rubygems')
            end

            env.announce.tap do |a|
              a << trace_sh_command("ruby --version")
              a << trace_sh_command("gem --version")
              a << trace_sh_command("bundle --version")
            end

            env.install.tap do |i|
              bundler_args = env.source.bundler_args.first
              i << trace_sh_command("bundle install #{bundler_args}")
              i << trace_sh_command("bundle clean --force")
            end

            if env.source.script.empty?
              script = "test -f Rakefile && #{trace_sh_command "bundle exec rake"} || true"
              env.script << script
            end

            if env.source.cached_directories != false
              env.cached_directories.push "~/.rubygems"
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.rvm.first || env.source.language == 'ruby'
          end

          def ruby(env)
            env.source.rvm.first || DEFAULT_RUBY
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
                grep '#{ruby env}' |
                tail -n1)
            }.gsub(/\n/, ' ').gsub(/ +/, ' ').strip
          end

      end
    end
  end
end
