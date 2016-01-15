module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < MultiBranch

        def self.symbol=(symbol)
          @symbol = symbol
        end

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
