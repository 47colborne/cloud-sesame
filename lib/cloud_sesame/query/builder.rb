module CloudSesame
	module Query
		class Builder
			extend SearchableSpecific
			include DSL::AppliedFilterQuery
			include DSL::BlockStyledOperators
			include DSL::FieldAccessors
			include DSL::PageMethods
			include DSL::QueryMethods
			include DSL::ResponseMethods
			include DSL::ReturnMethods
			include DSL::ScopeAccessors
			include DSL::SortMethods


			# SearchableSpecific construct class callback
			#
			# after construct searchable specific builder,
			# construct searchable specific DSL::FieldAccessors,
			# and Domain::Block and include the new field accessors
			# in both builder and domain block
			# ===================================================
			after_construct do |searchable|
				@field_accessor = DSL::FieldAccessors.construct_module(searchable)
				@block_domain = Domain::Block.construct_class(searchable, modules: [field_accessor])
				include field_accessor
			end

			# Domain::Block getter
			def self.block_domain
				@block_domain ||= Domain::Block
			end

			# DSL::FieldAccessors getter
			def self.field_accessor
				@field_accessor
			end

			# ===================================================

			attr_reader :context, :searchable

			def initialize(context, searchable)
				@context = context
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

			private

			def _block_domain(block)
				if block
					caller = block.binding.eval("self")
					self.class.block_domain.new caller, _context
				end
			end

			def _scope
				request.filter_query.root
			end

			def _context
				_scope.context
			end

			def _return
				self
			end

		end
	end
end
