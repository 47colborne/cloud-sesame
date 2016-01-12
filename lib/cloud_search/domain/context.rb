module CloudSearch
  module Domain
    class Context

      attr_reader :table

      def initialize(table = {})
        @table = table
      end

      def [](key, find_or_create = false)
        find_or_create ? table[key] ||= Context.new : table[key]
      end

      def []=(key, value)
        table[key] = value
      end

      def each(&block)
        table.each &block
      end

      def map(&block)
        table.map &block
      end

    end
  end
end
