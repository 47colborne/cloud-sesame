module CloudSesame
  module Query
    module AST
      class Operator
        SYMBOL = nil

        attr_reader :context, :options

        def initialize(context, options = {}, &block)
          @context = context
          @options = options
          instance_eval &block if block_given?
        end

        def boost
          " boost=#{ options[:boost] }" if options[:boost]
        end

        def symbol
          self.class::SYMBOL
        end

      end
    end
  end
end
