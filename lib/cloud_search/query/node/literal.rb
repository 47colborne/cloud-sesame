module CloudSearch
  module Query
    module Node
      class Literal

        attr_accessor :field, :value

        def initialize(field, value)
          @field = field
          @value = Value.new(value)
        end

        def compile
          [field, value.compile].join(':')
        end

      end
    end
  end
end
