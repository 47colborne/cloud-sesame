module CloudSesame
	module Domain
		class Config < CloudSesame::Config::Credential
			accept :sigv4_region, as: [:region]
			accept :endpoint, as: [:search_endpoint]
		end
	end
end
