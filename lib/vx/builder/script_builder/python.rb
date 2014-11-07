module Vx
  module Builder
    class ScriptBuilder

      class Python < Base

        DEFAULT_PYTHON = '2.7'
        VIRTUALENV_ROOT = "~/.python-virtualenv"
        PIP_DOWNLOADS = "~/.pip-downloads"
        PIP_OPTS = " --download-cache=#{PIP_DOWNLOADS}"

        def call(env)
          if enabled?(env)

            py_v = python_version(env)

            vxvm_install(env, 'python', py_v)

            do_init(env) do |i|
              i << "export TRAVIS_PYTHON_VERSION=#{py_v}" # for tornado
            end

            do_before_install(env) do |i|
              i << trace_sh_command("virtualenv #{VIRTUALENV_ROOT}")
              i << trace_sh_command("source #{VIRTUALENV_ROOT}/bin/activate")
            end

            do_announce(env) do |i|
              i << trace_sh_command("python --version")
              i << trace_sh_command("pip --version")
            end

            do_install(env) do |i|
              i << "if [ -f Requirements.txt ] ; then \n #{trace_sh_command "pip install -r Requirements.txt #{PIP_OPTS}"}\nfi"
              i << "if [ -f requirements.txt ] ; then \n #{trace_sh_command "pip install -r requirements.txt #{PIP_OPTS}"}\nfi"
              i << "if [ -f setup.py ] ; then \n #{trace_sh_command "python setup.py install"}\nfi"
            end

            do_before_script(env) do |i|
              i << trace_sh_command("vx_builder python:django:settings")
            end

            do_script(env) do |i|
              script =<<EOF
              if [[ -f manage.py ]] ; then
                #{trace_sh_command 'python manage.py test'}
              elif [[ -f setup.py ]] ; then
                #{trace_sh_command 'python setup.py test'}
              else
                #{trace_sh_command 'nosetests'}
              fi
EOF
              i << script
            end

            do_cache_key(env) do |i|
              i << "python-#{py_v}"
            end

            do_cached_directories(env) do |i|
              i << PIP_DOWNLOADS
            end
          end

          app.call(env)
        end

        private

          def enabled?(env)
            env.source.python.first || env.source.language == 'python'
          end

          def python_version(env)
            v = env.source.python.first
            v || DEFAULT_PYTHON
          end

      end
    end
  end
end
