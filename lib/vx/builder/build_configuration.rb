require 'yaml'

Dir[File.expand_path("../build_configuration/**/*.rb", __FILE__)].each do |f|
  require f
end

module Vx
  module Builder
    class BuildConfiguration

      REQUIRED_KEYS = %w{
        rvm
        scala
        jdk
        go
        node_js
        rust
        python
        php

        language
        script
      }

      ATTRIBUTES = %w{
        rvm
        scala
        jdk
        go
        node_js
        rust
        python
        php

        language
        gemfile
        services
        image

        bundler_args
        pip_args

        before_install
        install
        before_script
        script
        after_success

        before_deploy
        after_deploy

        workdir

        parallel
        parallel_job_number

        database
        git_args
      }

      class << self
        def from_yaml(yaml)
          hash = YAML.load(yaml)
          new hash
        end

        def from_file(file)
          if File.readable? file
            from_yaml File.read(file)
          end
        end
      end

      attr_reader :env, :cache, :deploy, :attributes, :deploy_modules, :vexor,
        :matrix

      def initialize(new_attributes = {}, matrix_attributes = {})
        new_attributes = {} unless new_attributes.is_a?(Hash)

        @is_empty            = new_attributes == {}
        @env                 = Env.new       new_attributes.delete("env")
        @cache               = Cache.new     new_attributes.delete("cache")
        @vexor               = Vexor.new     new_attributes.delete("vexor")
        @matrix              = Matrix.new    new_attributes.delete("matrix")

        @deploy              = Deploy.new    new_attributes.delete("deploy")
        @deploy_modules      = new_attributes.delete("deploy_modules") || []
        @deploy_modules      = Deploy.restore_modules(@deploy_modules)

        @matrix_attributes   = matrix_attributes.inject({}) do |a, pair|
          k,v = pair
          if k == 'parallel_job_number'
            k = 'parallel'
          end
          a[k] = v
          a
        end

        build_attributes new_attributes
      end

      # nil or empty configuration file
      def empty?
        @is_empty
      end

      # have any required attributes
      def any?
        REQUIRED_KEYS.any? do |key|
          attributes[key].any?
        end
      end

      # for deploy builder
      def flat_matrix_attributes
        @matrix_attributes
      end

      def matrix_attributes
        @matrix_attributes.inject({}) do |a,pair|
          k,v = pair
          if k == 'env'
            v = v["matrix"].first
          end
          if v
            a[k] = v
          end
          a
        end
      end

      def deploy?
        deploy.attributes.any?
      end

      def deploy_modules?
        deploy_modules.any?
      end

      # for tests
      def matrix_id
        matrix_attributes.to_a.map{|i| i.join(":") }.sort.join(", ")
      end

      def to_hash
        if empty?
          {}
        else
          attributes.merge(
            "env"            => env.attributes,
            "cache"          => cache.attributes,
            "vexor"          => vexor.attributes,
            "matrix"         => matrix.attributes,
            "deploy"         => deploy.attributes,
            "deploy_modules" => deploy_modules.map(&:to_hash)
          )
        end
      end

      def to_yaml
        to_hash.to_yaml
      end

      def env_matrix
        env.matrix
      end

      def language
        @attributes["language"].first
      end

      def parallel
        @attributes["parallel"].first.to_i
      end

      def database?
        @attributes['database'].first != false
      end

      def parallel?
        parallel > 0
      end

      def parallel_job_number
        @attributes["parallel_job_number"].first.to_i
      end

      def parallel_job_number?
        parallel_job_number > 0
      end

      def cached_directories
        cache.enabled? and cache.directories
      end

      (ATTRIBUTES - %w{ language parallel parallel_job_number }).each do |attr|
        define_method attr do
          attributes[attr]
        end
      end

      def services_map
        (services || []).inject({}) do |buffer, service|
          case service
          when Array
            buffer[service[0]] = service[1].to_s
          when Hash
            service.each do |k,v|
              buffer[k] = v.to_s
            end
          else
            buffer[service] = "local"
          end
          buffer
        end
      end


      private

        def build_attributes(new_attributes)
          @attributes = ATTRIBUTES.inject({}) do |ac, attribute_name|
            attribute = new_attributes[attribute_name]
            ac[attribute_name] = Array(attribute)
            ac
          end
        end

    end
  end
end
