module CloudSesame
  module Query
    module AST
      class Literal

        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

        attr_accessor :field
        attr_reader :options, :value

        def initialize(field, value = nil, options = {}, &block)
          @field = field
          @value = Value.parse value if value
          @value = Value.parse(ValueEvaluator.new.instance_exec &block) if block_given?

          @options = options
          is_included
        end

        def is_for(field, options = {})
          @field = field
          @options = options.merge @options
        end

        def is_included
          applied[value] = true
        end

        def is_excluded
          applied[value] = applied[value] == false ? true : false
        end

        def as_field
          options[:as] || field
        end

        def compile(detailed = false)
          detailed ? detailed_format : standard_format
        end

        private

        def applied
          options[:applied] ||= {}
        end

        def standard_format
          "#{ as_field }:#{ value.compile }"
        end

        def detailed_format
          "field=#{ escape as_field.to_s } #{ value.compile }"
        end

        def escape(data)
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

        class ValueEvaluator
          include DSL::RangeMethods
        end

      end
    end
  end
end
