module CloudSearch
  module Query
    module AST
      class Or < Operator
        self.symbol = :or
      end
    end
  end
end
