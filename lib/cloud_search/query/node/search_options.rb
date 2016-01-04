module CloudSearch
	module Query
		module Node
			class SearchOptions

				def sort
					@sort ||= Sort.new
				end

			end
		end
	end
end
