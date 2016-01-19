module CloudSesame
  module Query
    module AST
      class Literal

        attr_accessor :field
        attr_reader :options, :value

        def initialize(field = nil, value = nil, options = {}, &block)
          @field = field
          @value = valufy value
          @options = options || {}
          (@options[:included] ||= []) << @value

          @value = valufy(Evaluator.new.instance_eval &block) if block_given?
        end

        def is_for(field, options)
          @field = field
          @options = options.merge @options
        end

        def is_excluded
          options[:included].delete value
          (options[:excluded] ||= []) << value
        end

        def as_field
          options[:as] || field
        end

        def compile(detailed = false)
          detailed ? detailed_format : standard_format
        end

        private

        def valufy(value)
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

        class Evaluator
          include DSL::RangeMethods
        end

      end
    end
  end
end
