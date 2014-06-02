require 'yaml'

Dir[File.expand_path("../build_configuration/**/*.rb", __FILE__)].each do |f|
  require f
end

module Vx
  module Builder
    class BuildConfiguration

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

      attr_reader :env, :cache, :artifacts, :deploy, :attributes

      def initialize(new_attributes = {}, matrix_attributes = {})
        new_attributes = {} unless new_attributes.is_a?(Hash)

        @env       = Env.new(new_attributes["env"])
        @cache     = Cache.new(new_attributes["cache"])
        @artifacts = Artifacts.new(new_attributes["artifacts"])
        @deploy    = Deploy.new(new_attributes["deploy"])

        @matrix_attributes = matrix_attributes

        build_attributes new_attributes
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
        !deploy.attributes.empty?
      end

      def deploy_attributes= (val)
        @deploy = Deploy.new(val)
      end

      # for tests
      def matrix_id
        matrix_attributes.to_a.map{|i| i.join(":") }.sort.join(", ")
      end

      def to_hash
        attributes.merge("env"       => env.attributes)
                  .merge("cache"     => cache.attributes)
                  .merge("artifacts" => artifacts.attributes)
                  .merge("deploy"    => deploy.attributes)
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
        @cache.enabled? and @cache.directories
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
