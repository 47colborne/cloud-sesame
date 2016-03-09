module CloudSesame
	module Query
		module SearchableSpecific

			def construct_class(searchable, modules: [])
				__constructor__(searchable) do |name|
					constructed = __define_class__(name, self, modules)
					if __constructor_callback__
						constructed.class_exec(searchable, &__constructor_callback__)
					end
					constructed
				end
			end

			def construct_module(searchable)
				__constructor__(searchable) do |name|
					constructed = __define_module__(name, self)
					if __constructor_callback__
						constructed.module_eval(searchable, &__constructor_callback__)
					end
					constructed
				end
			end

			def after_construct(&block)
				__constructor_callback__(block)
			end

			private

			def __constructor__(klass)
				name = __get_constant_name__(klass)
				constants(false).include?(name.to_sym) ? const_get(name) : yield(name)
			end

			def __constructor_callback__(block = nil)
				block ? @constructor_callback = block : @constructor_callback
			end

			def __define_class__(name, parent, modules = [])
				parent.const_set(name, Class.new(parent) { modules.each { |m| include m }})
			end

			def __define_module__(name, parent)
				parent.const_set(name, parent.clone)
			end

			def __get_constant_name__(constant)
				constant.to_s.slice(/(?=\:\:)?\w+$/)
			end

		end
	end
end
