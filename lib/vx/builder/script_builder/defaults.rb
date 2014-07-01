module Vx
  module Builder
    class ScriptBuilder

      class Defaults < Base

        def call(env)
          env.source.before_install.each do |c|
            env.before_install << trace_sh_command(c)
          end

          env.source.install.each do |c|
            env.install << trace_sh_command(c)
          end

          env.source.before_script.each do |c|
            env.before_script << trace_sh_command(c)
          end

          env.source.script.each do |c|
            env.script << trace_sh_command(c)
          end

          env.source.after_success.each do |c|
            env.after_success << trace_sh_command(c)
          end

          app.call env
        end

      end
    end
  end
end
