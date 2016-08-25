module CloudSesame
	module Query
		module Node
			class Page < Abstract

				attr_writer :page, :size, :start, :cursor

        def page
					@page ||= context[:page] || 1
        end

				def size
					@size ||= context[:size] || 10
				end

				def start
					@start ||= (page - 1) * size
				end

				def cursor
					@cursor ||= context[:cursor]
				end

				def compile
					compiled = { size: size }
					cursor ? compiled[:cursor] = cursor : compiled[:start] = start
					compiled
				end

			end
		end
	end
end
