require 'cloud_sesame/domain/client_module/caching'

module CloudSesame
	module Domain
		class Client
			include ClientModule::Caching

			attr_reader :searchable

			def self.configure
				yield global_config if block_given?
			end

			def self.global_config
				@global_config ||= Config.new
			end

			def initialize(searchable)
				@searchable = searchable
			end

			def config
				@config ||= Config.new self.class.global_config
			end

			def search(params)
				executor.fetch params
			end

			private

			def aws_client
				@aws_client ||= ::Aws::CloudSearchDomain::Client.new config.to_hash
			end

		end
	end
end
