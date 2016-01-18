module CloudSesame
  module Query
    module AST
      class Operator
        SYMBOL = nil

        attr_reader :context, :options

        def initialize(context, options = {}, &block)
          @context = context
          @options = options
          evaluate &block if block_given?
        end

        def boost
          " boost=#{ options[:boost] }" if options[:boost]
        end

        def evaluate(&block)
          instance_eval &block
        end

      end
    end
  end
end
