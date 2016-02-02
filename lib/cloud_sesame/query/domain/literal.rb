module CloudSesame
	module Query
		module Domain
			class Literal
				include DSL::RangeMethods

				attr_reader :_name, :_options, :_scope

				def initialize(_name, _options, _scope = nil)
					@_name = _name
					@_options = _options
					@_scope = _scope
				end

				def _eval(&block)
					if block_given? && (_value = instance_exec &block)
						node = AST::Literal.new _name, _value, _options
						_scope << node if _scope
						node
					elsif _scope
						_scope
					end
				end

			end
		end
	end
end
