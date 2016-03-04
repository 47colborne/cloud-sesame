module CloudSesame
  module Query
    module AST
      class Near < Abstract::SingleExpressionOperator
        DETAILED = true
				SYMBOL = :near

				def compile(_detailed = nil)
          if child && (compiled = child.compile operator_detailed) && !compiled.empty?
            "(#{ symbol }#{ boost }#{ distance } #{ compiled })"
          end
				end

        def distance
          " distance=#{ options[:distance] }" if options[:distance]
        end

      end
    end
  end
end
