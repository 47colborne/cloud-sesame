module CloudSearch
  module Query
    module AST
      class Operator < MultiBranch

        def self.operator_symbol(symbol)
          @symbol = symbol
        end

        def self.symbol
          @symbol
        end

        def compile
          "(#{ self.class.symbol  } #{ serialize_children })" unless children.empty?
        end

      end
    end
  end
end
