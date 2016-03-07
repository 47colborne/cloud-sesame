module CloudSesame
  module Query
    module AST
      class Literal

        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

        attr_reader :value

        def initialize(field, value, options = {})
          @field = field
          @options = options
          @value = LazyObject.new { (options[:type] || Value).parse(value) } if value
        end

        def is_for(field, options = {})
          @field = field
          @options.merge! options
        end

        def applied(included)
          { field: @field, value: @value, included: included } if @value
        end

        def as_field
          @options[:as] || @field
        end

        def compile(detailed = false)
          (detailed ? detailed_format : standard_format) if @value
        end

        private

        def standard_format
          "#{ as_field }:#{ @value.compile }"
        end

        def detailed_format
          "field=#{ escape as_field.to_s } #{ @value.compile }"
        end

        def escape(data)
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

      end
    end
  end
end
