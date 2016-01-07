module CloudSearch
  module Query
    module Node
      class Or < Operator

        def compile
          "(or #{ serialize_children })"
        end

      end
    end
  end
end
