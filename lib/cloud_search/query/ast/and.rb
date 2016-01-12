module CloudSearch
  module Query
    module AST
      class And < Operator
        self.symbol = :and
      end
    end
  end
end
