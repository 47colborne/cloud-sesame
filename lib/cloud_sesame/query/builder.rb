module CloudSesame
	module Query
		class Builder
			include DSL::Base
			include DSL::PageMethods
			include DSL::QueryMethods
			include DSL::ReturnMethods
			include DSL::SortMethods

			# # Filter Query DSL
			include DSL::BlockMethods
			include DSL::FieldMethods
			include DSL::FilterQueryMethods
			include DSL::ScopeMethods

			attr_reader :context, :searchable, :result

			def initialize(default_context, searchable)
				@context = default_context
				@searchable = searchable
			end

			def request
				@request ||= Node::Request.new context.dup
			end

			def response
				@response ||= search
			en

			def compile
				request.compile
			end

			def inspect
				"#<#{ self.class }:#{ object_id } #{ compile }>"
			end

			# ENDING METHODS
			# =========================================

			def found
				response.hits.found
			end

			def results
				response.hits.hit
			end

			def each(&block)
				results.each &block
			end

			def map(&block)
				results.map &block
			end

			def search
				compiled = request.compile
				raise Error::MissingQuery.new("Query or FilterQuery can not be empty!") if !compiled[:query] || compiled[:query].empty?
				@response = searchable.cloudsearch.client.search compiled
			end

			private

			def dsl_scope
				request.filter_query.root
			end

			def dsl_return(node = nil)
				self
			end

		end
	end
end
