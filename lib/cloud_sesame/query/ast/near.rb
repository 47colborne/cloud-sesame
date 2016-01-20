module CloudSesame
  module Query
    module AST
      class Near < SingleExpressionOperator
        DETAILED = true
				SYMBOL = :near

				def compile
          "(#{ symbol }#{ boost }#{ distance } #{ child.compile detailed })" if child
				end

        def distance
          " distance=#{ options[:distance] }" if options[:distance]
        end

      end
    end
  end
end
