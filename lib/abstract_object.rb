class AbstractObject

	def self.accept(key, options = {})
		key = key.to_sym
		set_definitions key, options
		define_accessor key, options
	end

	def initialize(options = {})
		raise "Definitions can not be empty" if self.class.definitions.empty?
		@attributes = rename filter options.kind_of?(AbstractObject) ? options.to_hash : options
	end

	def to_hash
		attributes.dup
	end

	private

	def self.define_accessor(key, options)
		aliases = options.delete(:as) || []
		define_reader key, [key, *aliases], options.delete(:default)
		define_writer key, [key, *aliases], options.delete(:callback)
	end

	def self.define_reader(key, aliases, default)
		aliases.each { |name| define_method name, &reader_block(key, default) }
	end

	def self.reader_block(key, default)
		default.is_a?(Proc) ? -> { attributes[key] ||= default.call(self) } : -> { attributes[key] ||= default }
	end

	def self.define_writer(key, aliases, callbacks)
		aliases.each { |name| define_method "#{ name }=", &writer_block(key, callbacks) }
	end

	def self.writer_block(key, callback)
		callback.is_a?(Proc) ? -> (value) { attributes[key] = callback.call(value) } : -> (value) { attributes[key] = value }
	end

	def self.set_definitions(key, options)
		[key, *options.fetch(:as, [])].each { |name| definitions[name] = key }
	end

	def self.definitions
		@definitions ||= (parent = self.superclass).respond_to?(:definitions) ? parent.definitions.dup : {}
	end

	def attributes
		@attributes ||= {}
	end

	def filter(attributes)
		attributes.delete_if { |key| self.class.definitions[key].nil? }
	end

	def rename(attributes)
		attributes.keys.each do |key|
			if (name = self.class.definitions[key])
				attributes[name] = attributes.delete(key)
			end
		end
		attributes
	end

end
