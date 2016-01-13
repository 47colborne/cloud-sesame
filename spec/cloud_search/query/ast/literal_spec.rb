require "spec_helper"

module CloudSearch
  module Query
    module AST
      describe Literal do
        let(:literal) { Literal.new('description', 'Shoes') }
        let(:value) { Value.new("Shoes") }

        # before { allow(Value).to receive(:new).and_return(value) }

        describe '#initialize' do
          it 'should store field' do
            expect(literal.field).to eq('description')
          end
          it 'should create value node and store it' do
            expect(Value).to receive(:new).with('Shoes').and_return(value)
            expect(literal.value).to be_kind_of Value
          end
        end

        describe '#compile' do
          context 'when options is empty' do
            it 'should compile value' do
              expect_any_instance_of(Value).to receive(:compile).and_return("'Shoes'")
              literal.compile
            end
            it 'should join the field and compiled value with colon' do
              expect(literal.compile).to eq("description:'Shoes'")
            end
          end
        end

      end
    end
  end
end
