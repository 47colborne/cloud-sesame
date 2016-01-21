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
require 'cloud_sesame/query/error/invalid_syntax'
require 'cloud_sesame/query/error/missing_operator_symbol'
require 'cloud_sesame/query/error/missing_query'

# Query DSL Methods
# ===============================================
require 'cloud_sesame/query/dsl/base'
require 'cloud_sesame/query/dsl/block_methods'
require 'cloud_sesame/query/dsl/block_chaining_methods'
require 'cloud_sesame/query/dsl/field_array_methods'
require 'cloud_sesame/query/dsl/field_methods'
require 'cloud_sesame/query/dsl/filter_query_methods'
require 'cloud_sesame/query/dsl/operator_methods'
require 'cloud_sesame/query/dsl/page_methods'
require 'cloud_sesame/query/dsl/query_methods'
require 'cloud_sesame/query/dsl/range_methods'
require 'cloud_sesame/query/dsl/return_methods'
require 'cloud_sesame/query/dsl/scope_methods'
require 'cloud_sesame/query/dsl/sort_methods'

# Query Query Filter Query AST Tree
# ===============================================
require 'cloud_sesame/query/ast/operator'
require 'cloud_sesame/query/ast/multi_expression_operator'
require 'cloud_sesame/query/ast/single_expression_operator'
require 'cloud_sesame/query/ast/block_chaining_relation'
require 'cloud_sesame/query/ast/field_array'
require 'cloud_sesame/query/ast/and'
require 'cloud_sesame/query/ast/or'
require 'cloud_sesame/query/ast/not'
require 'cloud_sesame/query/ast/near'
require 'cloud_sesame/query/ast/phrase'
require 'cloud_sesame/query/ast/prefix'
require 'cloud_sesame/query/ast/term'
require 'cloud_sesame/query/ast/literal'
require 'cloud_sesame/query/ast/value'
require 'cloud_sesame/query/ast/date_value'
require 'cloud_sesame/query/ast/numeric_value'
require 'cloud_sesame/query/ast/range_value'
require 'cloud_sesame/query/ast/root'

# Query Request Nodes
# ===============================================
require 'cloud_sesame/query/node/abstract'
require 'cloud_sesame/query/node/request'
require 'cloud_sesame/query/node/query'
require 'cloud_sesame/query/node/fuzziness'
require 'cloud_sesame/query/node/query_options'
require 'cloud_sesame/query/node/query_options_field'
require 'cloud_sesame/query/node/query_parser'
require 'cloud_sesame/query/node/filter_query'
require 'cloud_sesame/query/node/facet'
require 'cloud_sesame/query/node/page'
require 'cloud_sesame/query/node/sort'
require 'cloud_sesame/query/node/return'

# Query Builder Interface
# ===============================================
require 'cloud_sesame/query/builder'

# Domain Objects
# ===============================================
require 'cloud_sesame/domain/base'
require 'cloud_sesame/domain/client'
require 'cloud_sesame/domain/config'

require 'cloud_sesame/context'

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
      if block_given?
        cloudsearch.definition = block
        cloudsearch.instance_eval &block
      end
    end

    def load_definition_from(klass)
      if klass.respond_to?(:cloudsearch) && klass.cloudsearch.definition
        cloudsearch.instance_eval &klass.cloudsearch.definition
      end
    end

  end

end
