module CloudSesame
  module Query
    module Node
      class QueryOptions < Abstract

        def fields
          @fields ||= build(context[:fields])
        end

        def compile
          JSON.dump({ fields: compile_fields }) unless fields.empty?
        end

        private

        def compile_fields
          fields.map(&:compile)
        end

        def build(fields)
          fields ? fields.map { |field, opt| build_field(field, opt) } : []
        end

        def build_field(field, options)
          QueryOptionsField.new field, options[:weight]
        end

      end
    end
  end
end
