module CloudSesame
	module Query
		class Scope

			attr_reader :_scope, :_return

			def initialize(_scope, _return)
				@_scope, @_return = _scope, _return
			end

			def _context
				_scope.context
			end

			def <<(object)
				_scope << object
			end

		end
	end
end
