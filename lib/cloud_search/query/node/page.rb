module CloudSearch
	module Query
		module Node
			class Page < Base

				attr_accessor :page, :size

				def initialize(context)
					@page = context[:page] || 1
					@size = context[:size] || 10
					super
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
