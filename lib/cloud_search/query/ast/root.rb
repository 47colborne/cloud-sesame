module CloudSearch
  module Query
    module AST
      class Root < MultiBranch

        def compile
          if children.size > 1
            join_by_default_operator.compile
          else
            compile_children
          end
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
