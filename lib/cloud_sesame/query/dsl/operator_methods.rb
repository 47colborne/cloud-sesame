module CloudSesame
	module Query
		module DSL
			module OperatorMethods

				# NEAR: creates a single NEAR node
				# =======================================
				def near(value, options = {})
					_build_operator AST::Near, options, value
				end

				alias_method :sloppy,     :near

				# PREFIX: creates a single PREFIX node
				# =======================================
				def prefix(value, options = {})
					_build_operator AST::Prefix, options, value
				end

				alias_method :start_with,	:prefix
				alias_method :begin_with, :prefix

				# PHRASE: creates a single PHRASE node
				# =======================================
				def phrase(value, options = {})
					_build_operator AST::Phrase, options, value
				end

				# TERM: creates a single TERM node
				# =======================================
				def term(value, options = {})
					_build_operator AST::Term, options, value
				end

				private

				def _build_operator(klass, options, value)
					node = klass.new _context, options
					node << AST::Literal.new(nil, value)
					node
				end

			end
		end
	end
end
