module CloudSearch
  module Query
    module Node
      class And < Operator

        def compile
          "(and #{ serialize_children })"
        end

      end
    end
  end
end
