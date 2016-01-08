module CloudSearch
	module Query
		module Node
			class Page < Abstract

				attr_writer :page, :size

				def page
					@page ||= (context[:page] || 1)
				end

				def size
					@size ||= (context[:size] || 10)
				end

				def start
					(page - 1) * size
				end

				def compile
					{ start: start, size: size }
				end

			end
		end
	end
end
