module CloudSesame
  module Query
    module AST
      class Value < Leaf

        attr_reader :data

        def initialize(data)
          @data = data
        end

        def compile
          format data
        end

        def ==(value)
          data == value || compile == value
        end

        def to_s
          compile
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

        def escape(data = "")
          "'#{ data.to_s.gsub(/\'/) { "\\'" } }'"
        end

        def strip(string)
          string.gsub(/ /, '')
        end

      end
    end
  end
end
