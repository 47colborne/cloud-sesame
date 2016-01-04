module CloudSearch
	module Domain
		class Config < CloudSearch::Config::Credential
			accept :sigv4_region, as: [:region]
			accept :endpoint, as: [:search_endpoint]
		end
	end
end
