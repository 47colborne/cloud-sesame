module CloudSearch
  module Query
    module Node
      class QueryParser

        attr_accessor :type

        TYPES = [:simple, :structured, :lucene, :dismax]
        TYPES.each { |type| define_method(type) { self.type = type; self } }

        def initialize(context)
          @type = context[:query_parser] || :simple
        end

        def compile
          { query_parser: type.to_s }
        end

      end
    end
  end
end
