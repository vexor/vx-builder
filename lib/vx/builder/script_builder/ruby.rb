module Vx
  module Builder
    class ScriptBuilder

      class Ruby < Base

        DEFAULT_RUBY = '2.0.0'
        DEFAULT_BUNDLE_INSTALL_ARGS = "--clean --retry=3 --jobs=4"

        ALIASES = {
          'jruby-19mode' => 'jruby'
        }

        def call(env)
          if enabled?(env)
            vxvm_install(env, 'ruby', ruby_version(env))

            do_cache_key(env) do |i|
              i << "rvm-#{ruby_version env}"
              i << gemfile(env)
            end

            do_before_install(env) do |i|
              i << trace_sh_command("export RAILS_ENV=test")
              i << trace_sh_command("export RACK_ENV=test")
              i << trace_sh_command("export BUNDLE_GEMFILE=${PWD}/#{gemfile(env)}")
              i << trace_sh_command('export GEM_HOME=~/.rubygems')
            end

            do_announce(env) do |i|
              i << trace_sh_command("ruby --version")
              i << trace_sh_command("gem --version")
              i << trace_sh_command("bundle --version")
            end

            do_install(env) do |i|
              bundler_args = env.source.bundler_args.first || DEFAULT_BUNDLE_INSTALL_ARGS
              i << trace_sh_command("bundle install #{bundler_args}")
            end

            do_script(env) do |i|
              script = "if [ -f Rakefile ] ; then \n #{trace_sh_command "bundle exec rake"}\nfi"
              i << script
            end

            do_cached_directories(env) do |i|
              i << "~/.rubygems"
            end
          end

          if auto_build?(env)
            vxvm_install(env, 'ruby', DEFAULT_RUBY)

            do_init(env) do |i|
              src = File.read(File.expand_path("../../../../../bin/vx_ruby_auto_build", __FILE__))
              i << upload_sh_command("~/vx_ruby_auto_build", src)
              i << "sudo chmod 0755 ~/vx_ruby_auto_build"
            end

            do_script(env) do |i|
              i << "~/vx_ruby_auto_build"
            end

            do_cached_directories(env) do |i|
              i << "~/.rubygems"
            end
          end

          app.call(env)
        end

        private

          def auto_build?(env)
            env.source.empty?
          end

          def enabled?(env)
            env.source.rvm.first || env.source.language == 'ruby'
          end

          def ruby_version(env)
            v = env.source.rvm.first || DEFAULT_RUBY
            ALIASES[v] || v
          end

          def gemfile(env)
            env.source.gemfile.first || "Gemfile"
          end

      end
    end
  end
end
