module CloudSesame
  module Query
    module AST
      class Not < Abstract::SingleExpressionOperator
				SYMBOL = :not

        def compile
          if child && (compiled = child.compile) && !compiled.empty?
            "(#{ symbol  }#{ boost } #{ compiled })"
          end
        end

        def applied(included = true)
          child.applied(!included)
        end

      end
    end
  end
end
