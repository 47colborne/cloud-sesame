module CloudSearch
  module Query
    module AST
      class Root < MultiBranch

        def compile
          if children.size > 1
            inject_default_operator(children).compile
          else
            compile_children
          end
        end

        def default
          @default ||= And.new context
        end

        private

        def inject_default_operator(children)
          default.children.concat children
          default
        end

      end
    end
  end
end
