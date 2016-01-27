module CloudSesame
	module Query
		module Domain
			class Block
				include DSL::BlockMethods

				attr_reader :_caller, :_context, :_scopes

				def initialize(_caller, _context)
					@_caller = _caller
					@_context = _context
					@_scopes = []
				end

				def _eval(node, _scope = node, _return = _scope, &block)
					if block_given?
						_scope << node
						_scopes.push node
						instance_eval &block
						_scopes.pop
						_return
					else
						ChainingBlock.new _scope, _return, node
					end
				end

			end
		end
	end
end
