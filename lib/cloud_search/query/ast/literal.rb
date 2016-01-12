module CloudSearch
  module Query
    module AST
      class Literal < SingleBranch

        attr_accessor :field, :value, :options

        def initialize(field, value, options = {})
          @field = field
          @value = Value.new(value)
          @options = options
        end

        def compile
          options[:prefix] ? prefix_format : default_format
        end

        private

        def default_format
          "#{ field }:#{ value.compile }"
        end

        def prefix_format
          "(prefix field=#{ escape(field) } #{ value.compile })"
        end

        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

      end
    end
  end
end
