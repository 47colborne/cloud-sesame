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
      @table = hash
    end

    def [](key, default = nil)
      (result = table[key.to_sym]) ? result : default ? table[key.to_sym] = default : nil
    end

    def []=(key, value)
      table[key.to_sym] = value
    end

  end
end
