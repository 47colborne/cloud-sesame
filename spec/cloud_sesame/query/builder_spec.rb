require_relative 'dsl/field_accessors_spec'

module CloudSesame
  module Query
    describe Builder do

    	it_behaves_like 'FieldAccessors' do
				subject { Builder.new({}, "Searchable") }
    	end

    end
  end
end
