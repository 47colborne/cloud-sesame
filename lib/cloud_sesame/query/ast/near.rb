module CloudSesame
  module Query
    module AST
      class Near < SingleExpressionOperator
        DETAILED = true
				SYMBOL = :near

				def compile
          "(#{ SYMBOL }#{ boost }#{ distance } #{ child.compile DETAILED })" if child
				end

        def distance
          " distance=#{ options[:distance] }" if options[:distance]
        end

      end
    end
  end
end
