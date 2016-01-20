module CloudSesame
  module Query
    module AST
      class Value

        RANGE_FORMAT = /\A[\[\{].*[\]\}]\z/
        DIGIT_FORMAT = /\A\d+(.\d+)?\z/
        SINGLE_QUATE = /\'/
        ESCAPE_QUATE = "\\'"

        attr_reader :data

        def initialize(data)
          @data = data
        end

        def compile
          escape data
        end

        def to_s
          compile
        end

        def ==(value)
          value == data || value == compile
        end

        private

        def escape(data = "")
          "'#{ data.gsub(SINGLE_QUATE) { ESCAPE_QUATE } }'"
        end

        def strip(string)
          string.tr(" ", "")
        end

      end
    end
  end
end
