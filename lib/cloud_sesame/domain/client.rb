module CloudSesame
	module Domain
		class Client
			extend Forwardable

			def_delegator :aws_client, :search

			def self.configure
				yield global_config if block_given?
			end

			def self.global_config
				@global_config ||= Config.new
			end

			def config
				@config ||= Config.new self.class.global_config
			end

			private

			def aws_client
				@aws_client ||= ::Aws::CloudSearchDomain::Client.new config.to_hash
			end

		end
	end
end
