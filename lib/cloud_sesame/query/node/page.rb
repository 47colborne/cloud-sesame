module CloudSesame
	module Query
		module Node
			class Page < Abstract

				attr_writer :page, :size, :start

        def page
					@page ||= 1
        end

				def size
					@size ||= (context && context[:size]) || 10
				end

				def start
					@start ||= (page - 1) * size
				end

				def compile
					{ start: start, size: size }
				end

			end
		end
	end
end
