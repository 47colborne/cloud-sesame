module CloudSearch
	module Query
		module Methods
			extend Forwardable

			def_delegators :query, :text, :page, :size

			def query
				@query ||= Builder.new client, searchable_class
			end

			def clear
				@query = nil
			end

		end
	end
end
