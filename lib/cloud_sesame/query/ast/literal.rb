module CloudSesame
  module Query
    module AST
      class Literal
        include DSL::ValueMethods

        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

        attr_accessor :field
        attr_reader :options, :value

        def initialize(field = nil, value = nil, options = {}, &block)
          @field = field
          @value = to_value value if value
          @options = options || {}
          (@options[:included] ||= []) << @value

          @value = to_value ValueEvaluator.new.instance_exec &block if block_given?
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
          @as_field ||= (options[:as] || field).to_s
        end

        def compile(detailed = false)
          detailed ? detailed_format : standard_format
        end

        private

        def standard_format
          "#{ as_field }:#{ value.compile }"
        end

        def detailed_format
          "field=#{ escape as_field.to_s } #{ value.compile }"
        end

        class ValueEvaluator
          include DSL::RangeMethods
        end

      end
    end
  end
end
