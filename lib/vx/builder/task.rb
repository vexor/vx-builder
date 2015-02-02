module Vx
  module Builder
    class Task

      attr_reader :name, :src, :sha, :ssh_keys, :branch, :pull_request_id,
        :cache_url_prefix, :job_id, :build_id, :build_number, :job_number,
        :project_host, :project_token

      def initialize(options = {})
        @name                 = options[:name]
        @src                  = options[:src]
        @sha                  = options[:sha]
        @job_id               = options[:job_id]
        @build_id             = options[:build_id]
        @ssh_keys             = options[:ssh_keys]
        @branch               = options[:branch]
        @pull_request_id      = options[:pull_request_id]
        @cache_url_prefix     = options[:cache_url_prefix]
        @build_number         = options[:build_number]
        @job_number           = options[:job_number]
        @project_host         = options[:project_host]
        @project_token        = options[:project_token]

        validate!
      end

      private

        def validate!
          (name && src && sha && ssh_keys && branch && job_id && build_id &&
            build_number && job_number && project_host) or
            raise(MissingKeys)
        end

    end
  end
end
