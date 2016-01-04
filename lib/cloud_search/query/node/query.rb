module CloudSearch
	module Query
		module Node
			class Query

				def add(text)
					text_array << text
				end

				def run
					{ query: text_array.join(' ') }
				end

				private

				def text_array
					@text_array ||= []
				end

			end
		end
	end
end
