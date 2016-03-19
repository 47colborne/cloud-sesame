module CloudSesame
  module Query
    module AST
      class Not < Abstract::SingleExpressionOperator
        SYMBOL = :not

        def applied(included = true)
          child.applied !included
        end

        def compile
          if child && (compiled = child.compile) && !compiled.empty?
            "(#{ symbol  }#{ boost } #{ compiled })"
          end
        end

      end
    end
  end
end
