module CloudSesame
  module Query
    module AST
      class Root < MultiBranch

        def compile
          children.size > 1 ? join_by_default_operator.compile : compile_children
        end

        private

        def join_by_default_operator
          (default = And.new context).children.concat children
          default
        end

      end
    end
  end
end
