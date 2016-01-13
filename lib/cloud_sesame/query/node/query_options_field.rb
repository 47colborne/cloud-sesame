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
          "#{ field }#{ '^' + weight.to_s if weight }"
        end

      end
    end
  end
end
