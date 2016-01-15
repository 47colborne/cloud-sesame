module CloudSesame
  module Query
    module AST
      class Literal < SingleBranch

        attr_accessor :field
        attr_reader :value, :options

        def initialize(field, value, options = {})
          @field = field
          @value = to_value value

          ((@options = options)[:included] ||= []) << @value
        end

        def as_field
          options[:as] || field
        end

        def compile
          options[:detailed] ? detailed_format : standard_format
        end

        def detailed
          options[:detailed] = true
          return self
        end

        private

        def to_value(value)
          return value if value.kind_of? Value
          return RangeValue.new value if value.kind_of? Range
          return DateValue.new(value) if value.kind_of?(Date) || value.kind_of?(Time)
          Value.new value
        end

        def standard_format
          "#{ as_field }:#{ value.compile }"
        end

        def detailed_format
          "field=#{ escape as_field } #{ value.compile }"
        end

        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

      end
    end
  end
end
