module CloudSesame
  module Query
    module AST
      class Value < Leaf

        attr_accessor :data

        def initialize(data)
          @data = data
        end

        def compile
          format(data)
        end

        private

        def format(data)
          range?(data) || digits?(data) ? data : escape(data)
        end

        def range?(data)
          data =~ /^[\[\{].*[\]\}]$/
        end

        def digits?(data)
          data.to_s =~ /^\d+(.\d+)?$/
        end

        # "hello" => "'hello'"
        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

      end
    end
  end
end
