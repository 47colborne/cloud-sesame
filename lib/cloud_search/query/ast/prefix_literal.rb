module CloudSearch
  module Query
    module AST
      class PrefixLiteral < Literal

        def compile
          "(prefix field=#{ escape(field) } #{ value.compile })"
        end

        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

      end
    end
  end
end
