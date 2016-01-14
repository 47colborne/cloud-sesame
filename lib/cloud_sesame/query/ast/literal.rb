module CloudSesame
  module Query
    module AST
      class Literal < SingleBranch

        attr_accessor :field
        attr_reader :value, :options

        def initialize(field, value, options = {})
          @field = field
          @value = Value.new(value)
          @options = options
          (options[:included] ||= []) << value
        end

        def detailed
          options[:detailed] = true
          return self
        end

        def value=(value)
          @value = Value.new(value)
        end

        def compile
          options[:detailed] ? long_format : short_format
        end

        def as_field
          options[:as] || field
        end

        private

        def short_format
          "#{ as_field }:#{ value.compile }"
        end


        def long_format
          "field=#{ escape as_field } #{ value.compile }"
        end

        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

      end
    end
  end
end
