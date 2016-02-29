module CloudSesame
  class Context
    extend Forwardable

    def_delegators :table, :each,
                           :map,
                           :delete,
                           :select,
                           :include?,
                           :empty?

    attr_reader :table

    def initialize(hash = {})
      @table = hash.deep_dup
    end

    def [](key, default = nil)
      (result = table[key.to_sym]) ? result : default ? table[key.to_sym] = default : nil
    end

    def []=(key, value)
      table[key.to_sym] = value
    end

    def duplicate(context)
      @table = context.table.deep_dup
      self
    end

  end
end
