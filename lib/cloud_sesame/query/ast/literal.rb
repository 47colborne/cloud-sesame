module CloudSesame
  module Query
    module AST
      class Literal

        attr_accessor :field
        attr_reader :options, :value

        def initialize(field = nil, value = nil, options = {}, &block)
          @field = field
          @value = Value.create value if value
          @options = options || {}
          (@options[:included] ||= []) << @value

          @value = Value.create ValueEvaluator.new.instance_exec &block if block_given?
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

        def standard_format
          "#{ as_field }:#{ value.compile }"
        end

        def detailed_format
          "field=#{ escape as_field } #{ value.compile }"
        end

        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

        class ValueEvaluator
          include DSL::RangeMethods
        end

      end
    end
  end
end
