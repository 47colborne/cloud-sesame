# External Libraries
# ===============================================
require 'aws-sdk'

# Internal Libraries
# ===============================================
require 'abstract_object'
require 'cloud_search/config/credential'

require 'cloud_search/query/error/missing_operator_symbol'
require 'cloud_search/query/error/missing_query'


require 'cloud_search/query/dsl/base'
require 'cloud_search/query/dsl/and'
require 'cloud_search/query/dsl/or'
require 'cloud_search/query/dsl/literal'
require 'cloud_search/query/dsl/scope'
require 'cloud_search/query/dsl/filter_query'


require 'cloud_search/query/dsl'
require 'cloud_search/query/builder'

require 'cloud_search/query/ast/multi_branch'
require 'cloud_search/query/ast/single_branch'
require 'cloud_search/query/ast/leaf'
require 'cloud_search/query/ast/root'
require 'cloud_search/query/ast/operator'
require 'cloud_search/query/ast/and'
require 'cloud_search/query/ast/or'
require 'cloud_search/query/ast/literal'
require 'cloud_search/query/ast/value'

require 'cloud_search/query/node/abstract'
require 'cloud_search/query/node/request'
require 'cloud_search/query/node/query'
require 'cloud_search/query/node/query_options'
require 'cloud_search/query/node/query_options_field'
require 'cloud_search/query/node/query_parser'
require 'cloud_search/query/node/filter_query'
require 'cloud_search/query/node/facet'
require 'cloud_search/query/node/page'
require 'cloud_search/query/node/sort'

require 'cloud_search/domain/base'
require 'cloud_search/domain/client'
require 'cloud_search/domain/config'
require 'cloud_search/domain/context'


# Public Interface
# ===============================================
module CloudSearch

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def cloudsearch
      @cloudsearch ||= CloudSearch::Domain::Base.new self
    end

    def define_cloudsearch(&block)
      cloudsearch.instance_eval &block if block_given?
    end

  end

end
