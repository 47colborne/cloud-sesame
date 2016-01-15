module CloudSesame
  module Query
    module AST
      class SingleExpressionOperator < SingleBranch
        include DSL::Boost

        def self.symbol=(symbol)
          @symbol = symbol
        end

        def self.symbol
          @symbol
        end

        def compile
          "(#{ self.class.symbol  }#{ compile_boost } #{ child.compile })" if child
        end

      end
    end
  end
end
