# External Libraries
# ===============================================
require 'aws-sdk'
require 'forwardable'

# Internal Libraries
# ===============================================
require 'abstract_object'
require 'cloud_sesame/config/credential'

# Custom Errors
# ===============================================
require 'cloud_sesame/query/error/missing_operator_symbol'
require 'cloud_sesame/query/error/missing_query'

# Query DSL Methods
# ===============================================
require 'cloud_sesame/query/dsl/base'
require 'cloud_sesame/query/dsl/query'
require 'cloud_sesame/query/dsl/page'
require 'cloud_sesame/query/dsl/sort'
require 'cloud_sesame/query/dsl/and'
require 'cloud_sesame/query/dsl/or'
require 'cloud_sesame/query/dsl/range'
require 'cloud_sesame/query/dsl/literal'
require 'cloud_sesame/query/dsl/literal_helper'
require 'cloud_sesame/query/dsl/scope'
require 'cloud_sesame/query/dsl/filter_query'

# Query Query Filter Query AST Tree
# ===============================================
require 'cloud_sesame/query/ast/multi_branch'
require 'cloud_sesame/query/ast/single_branch'
require 'cloud_sesame/query/ast/root'
require 'cloud_sesame/query/ast/leaf'
require 'cloud_sesame/query/ast/multi_expression_operator'
require 'cloud_sesame/query/ast/and'
require 'cloud_sesame/query/ast/or'
require 'cloud_sesame/query/ast/single_expression_operator'
require 'cloud_sesame/query/ast/not'
require 'cloud_sesame/query/ast/near'
require 'cloud_sesame/query/ast/prefix'
require 'cloud_sesame/query/ast/compound_array'
require 'cloud_sesame/query/ast/literal'
require 'cloud_sesame/query/ast/value'

# Query Request Nodes
# ===============================================
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

# Query Builder Interface
# ===============================================
require 'cloud_sesame/query/builder'

# Domain Objects
# ===============================================
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
