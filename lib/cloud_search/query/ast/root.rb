module CloudSearch
  module Query
    module AST
      class Root < MultiBranch

        def compile
          if children.size > 1
            default << children
            default.compile
          else
            serialize_children
          end
        end

        def default
          @default ||= And.new(context)
        end

      end
    end
  end
end
