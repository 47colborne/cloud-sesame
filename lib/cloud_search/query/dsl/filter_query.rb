module CloudSearch
	module Query
		module DSL
			module FilterQuery
				include And
				include Or
				include Scope
				include Literal

			end
		end
	end
end
