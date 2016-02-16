module CloudSesame
  module Query
    module Node
      class Sloppiness

        def initialize(value)
          @value = value.to_i
        end

        def compile(string)
          "\"#{ string }\"~#{ @value }" if more_than_one_word?(string)
        end

        private

        def more_than_one_word?(string)
          string.include?(' ')
        end

      end
    end
  end
end
