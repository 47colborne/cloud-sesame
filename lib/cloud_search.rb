# External Libraries
# ===============================================
require 'aws-sdk'
require 'active_support/concern'

# Internal Libraries
# ===============================================
require 'abstract_object'
require 'cloud_search/config/credential'

require 'cloud_search/query/error/invalid_format'

require 'cloud_search/query/parser'
require 'cloud_search/query/node/base'
require 'cloud_search/query/node/root'
require 'cloud_search/query/node/operator'
require 'cloud_search/query/node/and'
require 'cloud_search/query/node/or'
require 'cloud_search/query/node/literal'
require 'cloud_search/query/node/value'
require 'cloud_search/query/node/request'
require 'cloud_search/query/node/query'
require 'cloud_search/query/node/query_options'
require 'cloud_search/query/node/query_parser'
require 'cloud_search/query/node/filter_query'
require 'cloud_search/query/node/page'
require 'cloud_search/query/node/sort'
require 'cloud_search/query/builder'

require 'cloud_search/domain/base'
require 'cloud_search/domain/client'
require 'cloud_search/domain/config'
require 'cloud_search/domain/context'


# Public Interface
# ===============================================
module CloudSearch
	extend ActiveSupport::Concern

	included do

		def self.cloudsearch
			@cloudsearch ||= CloudSearch::Domain::Base.new(self)
		end

	end

end
