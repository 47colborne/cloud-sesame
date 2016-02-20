module CloudSesame
  module Query
    module Node
      class QueryOptions < Abstract

        def fields
          @fields ||= build(context[:fields])
        end

        def compile
          JSON.dump({ fields: compile_fields }) if fields
        end

        private

        def compile_fields
          fields.map(&:compile)
        end

        def build(fields)
          fields.map do |field, options|
            QueryOptionsField.new field, options[:weight]
          end if fields
        end

      end
    end
  end
end
