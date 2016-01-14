module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < MultiBranch

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
          "(#{ self.class.symbol  } #{ compile_children })" unless children.empty?
        end

      end
    end
  end
end
