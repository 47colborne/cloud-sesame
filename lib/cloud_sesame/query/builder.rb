module CloudSesame
	module Query
		class Builder
			include DSL::Base
			include DSL::PageMethods
			include DSL::QueryMethods
			include DSL::ReturnMethods
			include DSL::SortMethods

			# # Filter Query DSL
			# include DSL::BlockMethods
			include DSL::FieldMethods
			include DSL::FilterQueryMethods
			include DSL::ScopeMethods
			include DSL::ResponseMethods

			attr_reader :context, :searchable

			def initialize(context, searchable)
				@context = Context.new.duplicate context
				@searchable = searchable
			end

			def request
				@request ||= Node::Request.new context
			end

			def compile
				request.compile
			end

			def inspect
				"#<#{ self.class }:#{ object_id } #{ compile }>"
			end

			# OPERATOR METHODS
			# =========================================
			def and(options = {}, &block)
				node = AST::And.new _scope.context, options
				caller = block.binding.eval("self")
				domain = Domain::Block.new caller, _scope.context
				domain._eval node, _scope, self, &block
			end

			private

			def _eval(node, _scope, _return, &block)

			end

			def _scope
				request.filter_query.root
			end

		end
	end
end
