# External Libraries
# ===============================================
require 'aws-sdk'

# Internal Libraries
# ===============================================
require 'abstract_object'
require 'cloud_sesame/config/credential'

require 'cloud_sesame/query/error/missing_operator_symbol'
require 'cloud_sesame/query/error/missing_query'


require 'cloud_sesame/query/dsl/base'
require 'cloud_sesame/query/dsl/and'
require 'cloud_sesame/query/dsl/or'
require 'cloud_sesame/query/dsl/range'
require 'cloud_sesame/query/dsl/literal'
require 'cloud_sesame/query/dsl/scope'
require 'cloud_sesame/query/dsl/filter_query'


require 'cloud_sesame/query/dsl'
require 'cloud_sesame/query/builder'

require 'cloud_sesame/query/ast/multi_branch'
require 'cloud_sesame/query/ast/single_branch'
require 'cloud_sesame/query/ast/leaf'
require 'cloud_sesame/query/ast/root'
require 'cloud_sesame/query/ast/operator'
require 'cloud_sesame/query/ast/and'
require 'cloud_sesame/query/ast/or'
require 'cloud_sesame/query/ast/not'
require 'cloud_sesame/query/ast/literal'
require 'cloud_sesame/query/ast/compound_array'
require 'cloud_sesame/query/ast/prefix_literal'
require 'cloud_sesame/query/ast/value'

require 'cloud_sesame/query/node/abstract'
require 'cloud_sesame/query/node/request'
require 'cloud_sesame/query/node/query'
require 'cloud_sesame/query/node/query_options'
require 'cloud_sesame/query/node/query_options_field'
require 'cloud_sesame/query/node/query_parser'
require 'cloud_sesame/query/node/filter_query'
require 'cloud_sesame/query/node/facet'
require 'cloud_sesame/query/node/page'
require 'cloud_sesame/query/node/sort'

require 'cloud_sesame/domain/base'
require 'cloud_sesame/domain/client'
require 'cloud_sesame/domain/config'
require 'cloud_sesame/domain/context'


# Public Interface
# ===============================================
module CloudSesame

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def cloudsearch
      @cloudsearch ||= CloudSesame::Domain::Base.new self
    end

    def define_cloudsearch(&block)
      cloudsearch.instance_eval &block if block_given?
    end

  end

end
