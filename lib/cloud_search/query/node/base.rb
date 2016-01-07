module CloudSearch
  module Query
    module Node
      class Base
        attr_reader :context

        def initialize(context)
          @context = context
        end

      end
    end
  end
end
