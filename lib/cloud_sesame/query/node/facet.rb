module CloudSesame
  module Query
    module Node
      class Facet < Abstract

        def facet
          @facet ||= context
        end

        def compile
          JSON.dump(facet) unless facet.empty?
        end

      end
    end
  end
end
