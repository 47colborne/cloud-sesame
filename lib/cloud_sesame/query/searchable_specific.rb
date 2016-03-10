module CloudSesame
	module Query
		module SearchableSpecific

			def construct_class(searchable, modules: [])
				__constructor__(searchable) { |name| __define_class__(name, self, modules) }
			end

			def construct_module(searchable)
				__constructor__(searchable) { |name| __define_module__(name, self) }
			end

			def after_construct(&block)
				@__constructor_callback__ = block
			end

			private

			def __constructor__(searchable)
				constant = !(name = __get_constant_name__(searchable)) ? self :
									 constants(false).include?(name.to_sym) ? const_get(name) :
									 yield(name)

				__invoke_callback__(constant, searchable) if @__constructor_callback__
				constant
			end

			def __invoke_callback__(constant, searchable)
				constant.send(constant.is_a?(Class) ? :class_exec : :module_eval, searchable, &@__constructor_callback__)
			end

			def __define_class__(name, parent, modules = [])
				parent.const_set(name, Class.new(parent) { modules.each { |m| include m }})
			end

			def __define_module__(name, parent)
				parent.const_set(name, parent.clone)
			end

			def __get_constant_name__(constant)
				(name = constant.to_s) ? name.slice(/(?=\:\:)?\w+$/) : nil
			end

		end
	end
end
