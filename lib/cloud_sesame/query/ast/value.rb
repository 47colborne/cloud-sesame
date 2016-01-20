module CloudSesame
  module Query
    module AST
      class Value
        include DSL::ValueMethods

        attr_reader :data

        def initialize(data)
          @data = data
        end

        def compile
          escape data
        end

        def to_s
          compile
        end

        def ==(value)
          value == data || value == compile
        end

      end
    end
  end
end
