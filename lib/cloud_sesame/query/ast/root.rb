module CloudSesame
  module Query
    module AST
      class Root < And
        self.symbol = :and

        def compile
          children.size > 1 ? super : compile_children
        end

      end
    end
  end
end
