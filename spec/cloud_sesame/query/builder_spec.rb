require_relative 'dsl/field_accessors_spec'

module CloudSesame
  module Query
    describe Builder do

    	it_behaves_like 'FieldAccessors' do
				subject { Builder.new({}, "Searchable") }
        before {
        	Builder.include DSL::FieldAccessors
        	Domain::Block.include DSL::FieldAccessors
        	allow(_scope).to receive(:context).and_return(context)
        }
    	end

    end
  end
end
