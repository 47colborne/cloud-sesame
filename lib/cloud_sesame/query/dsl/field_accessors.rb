module CloudSesame
	module Query
		module DSL
			module FieldAccessors

				def literal(name, *values, &block)
					name = name.to_sym
					if block_given?
						caller = block.binding.eval "self"
						options = _scope.context[:fields][name]
						domain = Domain::Literal.new(name, options, caller)
						node = domain._eval(&block)
						values << node
					end
			  	_scope.children.field = name
			  	_scope.children._return = _return
			  	_scope.children.insert values
				end

				private

				def method_missing(method_name, *args, &block)
					if _context[:fields][method_name]
						literal(method_name, *args, &block)
					else
						super
					end
				end

			end
		end
	end
end
