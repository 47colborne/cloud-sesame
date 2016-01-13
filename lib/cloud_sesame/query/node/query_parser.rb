module CloudSesame
  module Query
    module Node
      class QueryParser < Abstract

        TYPES = %w(simple structured lucene dismax)

        attr_writer :type

        TYPES.each do |type|
          define_method type do
            self.type = type; self
          end
        end

        def type
          @type ||= (context[:query_parser] || :simple).to_s
        end

        def compile
          { query_parser: type.to_s }
        end

      end
    end
  end
end
