module CloudSesame
  module Query
    module AST
      class Not < SingleExpressionOperator
				SYMBOL = :not

        def <<(object)
          object.is_excluded
          super
        end

        def compile(detailed = nil)
          "(#{ self.class::SYMBOL  }#{ boost } #{ child.compile })" if child
        end

      end
    end
  end
end
