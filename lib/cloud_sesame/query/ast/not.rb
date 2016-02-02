module CloudSesame
  module Query
    module AST
      class Not < SingleExpressionOperator
				SYMBOL = :not

        def <<(object)
          object.is_excluded
          self.child = object
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
