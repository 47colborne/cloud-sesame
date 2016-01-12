require "spec_helper"

module CloudSearch
  module Query
    module AST
      describe Value do

        let(:value) { Value.new("Shoes") }

        describe '#initialize' do
          it 'should store the value' do
            expect(value.data).to eq("Shoes")
          end
        end

        describe '#compile' do
          shared_examples 'return raw data' do
            it 'should just return the data' do
              expect(value.compile).to eq value.data
            end
          end
          context 'when data is a string' do
            it 'should escape the string' do
              expect(value.compile).to eq "'#{value.data}'"
            end
          end
          context 'when data is a range' do
            let(:value) { Value.new('[100,}') }
            include_examples 'return raw data'
          end
          context 'when data is a digit' do
            let(:value) { Value.new(100) }
            include_examples 'return raw data'
          end
        end

      end
    end
  end
end
