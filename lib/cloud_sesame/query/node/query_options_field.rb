module CloudSesame
  module Query
    module Node
      class QueryOptionsField

        attr_reader :field, :weight

        def initialize(field, weight = nil)
          @field = field
          @weight = weight
        end

        def compile
          compiled = field.to_s
          compiled << '^' << weight.to_s if weight
          compiled
        end

      end
    end
  end
end
