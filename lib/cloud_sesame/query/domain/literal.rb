module CloudSesame
	module Query
		module Domain
			class Literal
				include DSL::BindCaller
				include DSL::RangeHelper

				attr_reader :_name, :_options, :_caller

				def initialize(_name, _options, _caller)
					@_name = _name
					@_options = _options
					self._caller = _caller
				end

				def _eval(&block)
					if block_given? && (_value = instance_exec(&block))
						AST::Literal.new _name, _value, _options
					end
				end

			end
		end
	end
end
