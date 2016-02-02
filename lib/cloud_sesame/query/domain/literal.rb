module CloudSesame
	module Query
		module Domain
			class Literal
				include DSL::RangeMethods

				attr_reader :_name, :_options, :_caller

				def initialize(_name, _options, _caller)
					@_name = _name
					@_options = _options
					@_caller = _caller

					_caller.instance_variables.each do |name|
						value = _caller.instance_variable_get name
						instance_variable_set name, value
					end
				end

				def _eval(&block)
					if block_given? && (_value = instance_exec &block)
						AST::Literal.new _name, _value, _options
					end
				end

				private

				# ACCESS CALLER'S METHODS
				# =========================================
				def method_missing(name, *args, &block)
					_caller.send(name, *args, &block)
				rescue NoMethodError
					super
				end

			end
		end
	end
end
