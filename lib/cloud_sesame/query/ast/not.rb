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
          "(#{ symbol  }#{ boost } #{ child.compile })" if child
        end

      end
    end
  end
end
