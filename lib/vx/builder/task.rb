module Vx
  module Builder
    class Task

      attr_reader :name, :src, :sha, :deploy_key, :branch, :pull_request_id,
        :cache_url_prefix, :artifacts_url_prefix, :job_id, :build_id

      def initialize(options = {})
        @name                 = options[:name]
        @src                  = options[:src]
        @sha                  = options[:sha]
        @job_id               = options[:job_id]
        @build_id             = options[:build_id]
        @deploy_key           = options[:deploy_key]
        @branch               = options[:branch]
        @pull_request_id      = options[:pull_request_id]
        @cache_url_prefix     = options[:cache_url_prefix]
        @artifacts_url_prefix = options[:artifacts_url_prefix]
        @deploy               = !!options[:deploy]

        validate!
      end

      def deploy?
        @deploy
      end

      private

        def validate!
          (name && src && sha && deploy_key && branch && job_id && build_id) or
            raise(MissingKeys)
        end

    end
  end
end
