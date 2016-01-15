module CloudSesame
  module Query
    module AST
      class Term < SingleExpressionOperator
        self.symbol = :term

        def compile
          child.detailed if child.kind_of?(Literal)
          super
        end
      end
    end
  end
end
