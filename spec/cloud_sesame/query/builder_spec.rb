require_relative 'dsl/applied_filter_query_spec'
require_relative 'dsl/literal_methods_spec'

module CloudSesame
  module Query
    describe Builder do

      it_behaves_like DSL::AppliedFilterQuery do
        subject { Builder.new({}, "Searchable") }
      end

      it_behaves_like DSL::LiteralMethods do
        subject { Builder.new({}, "Searchable") }
        before {
          Builder.send(:include, DSL::LiteralMethods)
          Domain::Block.send(:include, DSL::LiteralMethods)
          allow(_scope).to receive(:context).and_return(context)
        }
      end

    end
  end
end
