module CloudSesame
  module Query
    module Node
      class Facet < Abstract
        def facet
          @facet ||= context.table
        end
        def compile
          { facet: JSON.dump(facet) } unless facet.empty?
        end
      end
    end
  end
end
