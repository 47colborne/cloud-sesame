module CloudSesame
	module Query
		module Domain
			class Block
				include DSL::BlockMethods
				include DSL::FieldAccessors
        include DSL::FilterQueryMethods
        include DSL::OperatorMethods
        include DSL::RangeMethods
        include DSL::ScopeAccessors

				attr_reader :_caller, :_context, :_scopes

				def initialize(_caller, _context)
					@_caller = _caller
					@_context = _context
					@_scopes = []
				end

				def _eval(node, _scope, _return = _scope, &block)
					_scope << node
					_scopes.push node
					instance_eval &block
					_scopes.pop
					_return
				end

				def _scope
					_scopes[-1]
				end

				def _return
					_scope
				end

			end
		end
	end
end
