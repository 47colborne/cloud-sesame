require 'spec_helper'

module CloudSearch
  module Query
    module Node
      describe QueryOptions do

        let(:context) {{}}
        let(:query_options) { QueryOptions.new(context) }

        describe '#fields' do
          context 'when given the context' do
            context 'and context fields is an hash with fields and options' do
              let(:context) { { fields: { description: { weight: 2}, name: { weight: 1} } } }
              it 'should set the fields from context' do
                expect(query_options.fields).to include(QueryOptionsField)
                expect(query_options.fields[0].field).to eq :description
                expect(query_options.fields[0].weight).to eq 2
                expect(query_options.fields[1].field).to eq :name
                expect(query_options.fields[1].weight).to eq 1
              end
            end
          end
          context 'when not given the context' do
            it 'should default it to an empty hash' do
              expect(query_options.fields).to eq([])
            end
          end
          context 'when there are existing fields stored' do
            it 'should return the existing fields' do
              field = QueryOptionsField.new({ field: 'description' })
              query_options.fields << field
              expect(query_options.fields).to eq [field]
            end
          end
        end

        describe '#compile' do
          context 'when fields is empty' do
            it 'should return nil' do
              expect(query_options.compile).to eq(nil)
            end
          end
          context 'when fields is not empty' do
            let(:context) { {fields: { description: { weight: 2 }, name: {} } } }
            it 'should return a hash with query_options and fields as JSON' do
              expected_result = { fields: ['description^2', 'name'] }
              expect(query_options.compile).to include(query_options: JSON.dump(expected_result))
            end
          end
        end

      end
    end
  end
end
