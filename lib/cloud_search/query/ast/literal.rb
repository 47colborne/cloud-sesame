module CloudSearch
  module Query
    module AST
      class Literal < SingleBranch

        attr_accessor :field
        attr_reader :value, :options

        def initialize(field, value = nil, options = {})
          @field = field
          @value = Value.new(value) if value
          @options = options
        end

        def value=(value)
          @value = Value.new(value)
        end

        def compile
          "#{ field }:#{ value.compile }"
        end

      end
    end
  end
end
