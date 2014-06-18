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
        language
        script
      }

      ATTRIBUTES = %w{
        rvm
        scala
        jdk
        language

        gemfile
        services
        image
        bundler_args

        before_install
        before_script
        script
        after_success

        before_deploy
        after_deploy
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

      attr_reader :env, :cache, :deploy, :attributes, :deploy_modules

      def initialize(new_attributes = {}, matrix_attributes = {})
        new_attributes = {} unless new_attributes.is_a?(Hash)

        @env               = Env.new       new_attributes.delete("env")
        @cache             = Cache.new     new_attributes.delete("cache")
        @deploy            = Deploy.new    new_attributes.delete("deploy")
        @deploy_modules    = new_attributes.delete("deploy_modules") || []
        @deploy_modules    = Deploy.restore_modules(@deploy_modules)

        @matrix_attributes = matrix_attributes

        build_attributes new_attributes
      end

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
        attributes.merge(
          "env"            => env.attributes,
          "cache"          => cache.attributes,
          "deploy"         => deploy.attributes,
          "deploy_modules" => deploy_modules.map(&:to_hash)
        )
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

      def cached_directories
        cache.enabled? and cache.directories
      end

      (ATTRIBUTES - %w{ language }).each do |attr|
        define_method attr do
          attributes[attr]
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
