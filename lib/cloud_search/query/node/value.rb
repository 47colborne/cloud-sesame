module CloudSearch
  module Query
    module Node
      class Value

        attr_accessor :value

        def initialize(value)
          @value = value
        end

        def compile
          format(value)
        end

        private

        def format(value)
          range?(value) || digits?(value) ? value : escape(value)
        end

        def range?(value)
          value =~ /^[\[\{].*[\]\}]$/
        end

        def digits?(value)
          value =~ /^\d+$/
        end

        def escape(value = "")
          "'#{ value.gsub(/\'/) { "\\'" } }'"
        end

      end
    end
  end
end
