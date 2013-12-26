require 'shellwords'

module Vx
  module Builder
    module Helper

      module TraceShCommand
        def trace_sh_command(cmd, options = {})
          trace = options[:trace] || cmd
          "echo #{Shellwords.escape "$ #{trace}"}\n#{cmd}"
        end
      end

    end
  end
end
