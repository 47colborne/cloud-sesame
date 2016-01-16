module CloudSesame
  module Query
    module AST
      class Near < SingleExpressionOperator
        DETAILED = true
				SYMBOL = :near

				def compile
          "(#{ SYMBOL }#{ boost.compile if boost }#{ distance.compile if distance } #{ child.compile DETAILED })" if child
				end

        def distance
          options[:distance]
        end

        def distance=(value)
          options[:distance] = Distance.new value
        end

      end
    end
  end
end
