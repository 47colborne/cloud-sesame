module CloudSesame
	module Query
		module DSL
			module OperatorMethods

				# NEAR: creates a single NEAR node
				# =======================================
				def near(value, options = {})
					create_literal AST::Near, options, value
				end

				alias_method :sloppy,     :near

				# PREFIX: creates a single PREFIX node
				# =======================================
				def prefix(value, options = {})
					create_literal AST::Prefix, options, value
				end

				alias_method :start_with,	:prefix
				alias_method :begin_with, :prefix

				# PHRASE: creates a single PHRASE node
				# =======================================
				def phrase(value, options = {})
					create_literal AST::Phrase, options, value
				end

				# TERM: creates a single TERM node
				# =======================================
				def term(value, options = {})
					create_literal AST::Term, options, value
				end

				private

				def fields
					dsl_context[:fields]
				end

				def create_literal(klass, options, value)
					(node = klass.new dsl_context, options) << fieldless_literal(value)
					return node
				end

				def fieldless_literal(value)
					AST::Literal.new nil, value
				end

			end
		end
	end
end
