module CloudSearch
  module Query
    module Node
      class QueryOptions < Abstract

        def fields
          @fields ||= default_fields
        end

        def compile
          {
            query_options: JSON.dump({
              fields: compile_fields
            })
          } unless fields.empty?
        end

        private

        def compile_fields
          fields.map(&:compile)
        end

        def default_fields
          if context[:fields]
            context[:fields].map do |field, options|
              QueryOptionsField.new field, options[:weight]
            end
          else
            []
          end
        end

      end
    end
  end
end
