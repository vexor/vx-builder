module Vx
  module Builder
    class DeployBuilder

      BLACK_LIST = %w{
        image
        before_script
        after_success
        script
      }

      attr_reader :base_build_configuration, :matrix_build_configuration, :branch

      def initialize(matrix_builder, options = {})
        @base_build_configuration    = matrix_builder.build_configuration
        @matrix_build_configuration  = matrix_builder.build.first
        @branch                      = options[:branch]
      end

      def build
        @build ||= begin
          return false unless valid?

          hash = matrix_build_configuration.to_hash

          BLACK_LIST.each do |key|
            hash.delete key
          end

          hash["env"]["matrix"] = []

          BuildConfiguration.new(
            hash.merge(
              "deploy_modules" => deploy_modules,
              "deploy"         => nil
            )
          )
        end
      end

      def valid?
        deploy? and deploy_modules.any?
      end

      def deploy_modules
        @deploy_modules ||= deploy.find_modules(branch)
      end

      def deploy
        base_build_configuration.deploy
      end

      def deploy?
        deploy.attributes.any?
      end

    end
  end
end
