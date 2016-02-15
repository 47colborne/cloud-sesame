module CloudSesame
  module Query
    module AST
      class Operator
        SYMBOL = nil

        attr_reader :context, :options

        def initialize(context, options = {})
          @context = context
          @options = options
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
