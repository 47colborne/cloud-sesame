module CloudSesame
	module Query
		module Domain
			class Block
				include DSL::BlockMethods
				include DSL::FieldAccessors
				include DSL::ScopeAccessors
        include DSL::OperatorMethods
        include DSL::RangeMethods
				include DSL::FilterQueryMethods

				attr_reader :_caller, :_context, :_scopes

				def initialize(_caller, _context)
					@_caller = _caller
					@_context = _context
					@_scopes = []
				end

				def _eval(node, _scope, _return = _scope, &block)
					_scopes.push node

					# must build the subtree before push (<<) to it's
					# parents (_scope) in order for the parent properly
					# propagate message down to all the children.
					# ===============================================
					instance_eval &block
					_scope << node

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
