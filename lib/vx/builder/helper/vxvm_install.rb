require 'shellwords'

module Vx
  module Builder
    module Helper

      module VxvmInstall
        def vxvm_install(env, lang, version)
          vxvm_install = "sudo env PATH=$PATH vxvm install #{lang} #{version}"
          do_before_install(env) do |i|
            i << trace_sh_command(%{VX_VM_SOURCE="$(#{vxvm_install})"}, trace: vxvm_install)
            i << %{source "$VX_VM_SOURCE"}
          end
        end
      end

    end
  end
end
