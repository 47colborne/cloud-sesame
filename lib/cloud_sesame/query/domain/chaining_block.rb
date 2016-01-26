module CloudSesame
	module Query
		module Domain
			class ChainingBlock

				def initialize(_caller)
					@_caller = _caller
				end

				def _evaluate(_scope, _return, _node, &block)
					if block_given?
						instance_eval &block
						_scope << _node
						_return
					else
						BlockChaining.new _scope, _return, _node
					end
				end

			end
		end
	end
end
