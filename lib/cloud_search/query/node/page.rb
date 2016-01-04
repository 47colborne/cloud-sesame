module CloudSearch
	module Query
		module Node
			class Page

				attr_accessor :page, :size

				def initialize(default_size = 10)
					@size = default_size
				end

				def run
					{ start: (page - 1) * size, size: size }
				end

			end
		end
	end
end
