module CloudSearch
  module Domain
    class Context

      attr_reader :table

      def initialize(initial_context = {})
        @table = initial_context
      end

      def [](key, find_or_create = false)
        find_or_create ? table[key] ||= Context.new : table[key]
      end

      def []=(key, value)
        table[key] = value
      end

      def merge!(hash)
        table.merge!(hash)
        self
      end

      def delete(key)
        table.delete(key)
      end

      def include?(values)
        table.merge(values) == table
      end

      def keys
        table.keys
      end

      def values
        table.values
      end

      def key?(key)
        table.key? key
      end

    end
  end
end
