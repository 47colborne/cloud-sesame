module CloudSesame
  module Query
    module Node
      class FilterQuery < Abstract

        EXCESS_WHITESPACES = Regexp.new(/\s{2,}/).freeze
        ENDING_WHITESPACES = Regexp.new(/\s+\)$/).freeze

        def compile
          if (compiled = root.compile) && !(compiled = strip(compiled)).empty?
            compiled
          end
        end

        def root
          @root ||= CloudSesame::Query::AST::Root.new context
        end

        private

        def strip(string)
          string.gsub!(EXCESS_WHITESPACES, ' '.freeze)
          string.gsub!(ENDING_WHITESPACES, ')'.freeze)
          string
        end

      end
    end
  end
end
