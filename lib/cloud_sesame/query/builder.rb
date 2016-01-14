module CloudSesame
	module Query
		class Builder
			include DSL::Base
			include DSL::FilterQuery
			include DSL::Page
			include DSL::Query
			include DSL::Sort

			attr_accessor :context, :searchable_class
			attr_reader 	:result

			def initialize(default_context, searchable_class)
				@context = default_context
				@searchable_class = searchable_class
			end

			def request
				@request ||= (clear_result; Node::Request.new context.dup)
			end

			def clear_request
				@request = nil
			end

			def clear_result
				@result = nil
			end

			def inspect
				"#<CloudSesame::Query::Builder:#{ object_id } #{ request.compile }>"
			end

			# ENDING METHODS
			# =========================================

			def search
				compiled = request.compile
				raise Error::MissingQuery.new("Query or FilterQuery can not be empty!") if !compiled[:query] || compiled[:query].empty?
				clear_request
				@result = searchable_class.cloudsearch.client.search compiled
			end

			private

			def method_scope
				request.filter_query.root
			end

		end
	end
end
