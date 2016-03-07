require_relative 'dsl/field_accessors_shared_spec'

module CloudSesame
  module Query
    describe Builder do

    	it_behaves_like 'FieldAccessors' do
				subject { Builder.new({}, "Searchable") }
        before { allow(_scope).to receive(:context).and_return(context) }
    	end

    end
  end
end
