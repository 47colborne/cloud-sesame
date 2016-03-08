module CloudSesame
	module Query
		module SearchableSpecific

			def construct_class(searchable)
				constructor(searchable) do |name|
					constructed = define_class(name, self)
					if __constructor_callback__
						constructed.class_exec(constructed, searchable, &__constructor_callback__)
					end
					constructed
				end
			end

			def construct_module(searchable)
				constructor(searchable) do |name|
					constructed = define_module(name, self)
					if __constructor_callback__
						constructed.module_eval(constructed, searchable, &__constructor_callback__)
					end
					constructed
				end
			end

			def after_construct(&block)
				__constructor_callback__(block)
			end

			private

			def constructor(klass)
				name = extract_klass_name(klass)
				if self.constants.include?(name.to_sym)
					self.const_get(name)
				else
					yield(name)
				end
			end

			def __constructor_callback__(block = nil)
				block ? @constructor_callback = block : @constructor_callback
			end

			def define_class(name, parent)
				parent.const_set(name, Class.new(parent))
			end

			def define_module(name, parent)
				parent.const_set(name, Module.new { include parent })
			end

			def extract_klass_name(klass)
				klass.to_s.slice(/(?=\:\:)?\w+$/)
			end

		end
	end
end
