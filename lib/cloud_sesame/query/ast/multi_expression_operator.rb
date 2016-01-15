module CloudSesame
  module Query
    module AST
      class MultiExpressionOperator < MultiBranch
        include DSL::Boost

        def self.symbol=(symbol)
          @symbol = symbol
        end

        def self.symbol
          @symbol
        end

        def compile
          "(#{ self.class.symbol  }#{ compile_boost } #{ compile_children })" unless children.empty?
        end

      end
    end
  end
end
