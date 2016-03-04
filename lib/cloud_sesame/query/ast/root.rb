module CloudSesame
  module Query
    module AST
      class Root < Abstract::MultiExpressionOperator
        SYMBOL = :and # default operator for root

        def compile
          children.size > 1 ? super : children.compile
        end

        private

        def create_children
          array = FieldArray.new(context[:defaults] || [])
          array._scope = self
          array
        end

      end
    end
  end
end
