# External Libraries
# ===============================================
require 'aws-sdk'
require 'active_support/concern'

# Internal Libraries
# ===============================================
require 'abstract_object'
require 'cloud_search/config/credential'

require 'cloud_search/query/node/page'
require 'cloud_search/query/node/query'
require 'cloud_search/query/node/request'

require 'cloud_search/query/builder'
require 'cloud_search/query/methods'

require 'cloud_search/domain/base'
require 'cloud_search/domain/client'
require 'cloud_search/domain/config'


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
