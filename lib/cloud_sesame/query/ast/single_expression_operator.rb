module CloudSesame
  module Query
    module AST
      class SingleExpressionOperator < SingleBranch

        # Operator Symbol Writer
        def self.symbol=(symbol)
          @symbol = symbol
        end

        # Operator Symbol Getter
        def self.symbol
          @symbol
        end

        def compile
          raise Error::MissingOperatorSymbol if self.class.symbol.nil?
          "(#{ self.class.symbol  } #{ child.compile })" if child
        end

      end
    end
  end
end
