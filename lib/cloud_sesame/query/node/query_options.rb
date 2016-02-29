module CloudSesame
  module Query
    module Node
      class QueryOptions < Abstract

        def fields
          @fields ||= build(context[:fields])
        end

        def compile
          JSON.dump({ fields: fields.map(&:compile) }) unless fields.empty?
        end

        private

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
