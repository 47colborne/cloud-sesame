require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe QueryOptionsField do

        let(:query_options_field) { QueryOptionsField.new("description", weight) }

        describe '#compile' do
          context 'when weight is nil' do
            let(:weight) { nil }
            it 'should return a string with the field' do
              expect(query_options_field.compile).to eq("description")
            end
          end
          context 'when weight is not nil' do
            let(:weight) { 2 }
            it 'should return a string with the weight' do
              expect(query_options_field.compile).to eq("description^2")
            end
          end
        end
      end
    end
  end
end
