module CloudSesame
  module Query
    module Node
      class Abstract
        attr_reader :context

        def initialize(context = {})
          @context = context
        end
      end
    end
  end
end
