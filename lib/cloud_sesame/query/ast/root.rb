module CloudSesame
  module Query
    module AST
      class Root < Abstract::MultiExpressionOperator
        SYMBOL = :and # default operator for root

        def compile
          children.size > 1 ? super : children.compile
        end

        private

        def build_children
          MultiExpressionOperatorChildren.build(self, context[:defaults])
        end

      end
    end
  end
end
