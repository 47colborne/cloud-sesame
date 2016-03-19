module CloudSesame
  module Query
    module AST
      class Literal

        SINGLE_QUATE = Regexp.new(/\'/).freeze
        ESCAPE_QUATE = "\\'".freeze

        attr_reader :field, :value, :options

        def initialize(field, value, options)
          @field = field
          @options = options || default_options
          @value = parse_value(value) if value
        end

        def actual_field_name
          @options[:as] || @field
        end

        def applied(included)
          { field: @field, value: @value, included: included } if @value
        end

        def compile(detailed = false)
          (detailed ? detailed_format : standard_format) if @value
        end

        def is_for(field, options)
          @field = field
          @options.merge! options if options
        end

        private

        def standard_format
          "#{ actual_field_name }:#{ @value.compile }"
        end

        def detailed_format
          "field=#{ escape actual_field_name.to_s } #{ @value.compile }"
        end

        def escape(data)
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

        def parse_value(value)
          LazyObject.new { (@options[:type] || Value).parse(value) }
        end

        def default_options
          { type: Value }
        end

      end
    end
  end
end
