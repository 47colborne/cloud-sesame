require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe Sort do

        let(:context) {{ fields: {} }}
        let(:node) { Sort.new(context) }

        describe '#[]' do
          context 'with existing attribute' do
            before { node.sorting_attributes = { score: :asc, price: :desc }}
            it 'should return the sorting order of the attribute' do
              expect(node[:score]).to eq :asc
              expect(node[:price]).to eq :desc
            end
          end
          context 'with non-existing attribute' do
            it 'should return the sorting order of the attribute' do
              expect(node[:score]).to eq nil
              expect(node[:price]).to eq nil
            end
          end
        end

        describe '#[]=' do
          context 'with existing attribute' do
            before { node.sorting_attributes = { score: :asc, price: :desc }}
            it 'should override the sorting order of the attribute' do
              expect{ node[:score] = :desc }.to change{ node[:score] }.from(:asc).to(:desc)
            end
          end
          context 'with non-existing attribute' do
            it 'should add the sorting order of the attribute' do
              expect{ node[:test] = :asc }.to change{ node[:test] }.from(nil).to(:asc)
            end
          end
        end

        describe '#compile' do
          context 'with existing sorting attributes' do
            context 'when context contains aliase field' do
              let(:context) {{ fields: { aliased: { as: :real_name } } }}
              before { node.sorting_attributes = { aliased: :asc, price: :desc }}
              it 'should return serialized sort attributes with actual field name' do
                expect(node.compile).to eq "real_name asc,price desc"
              end
            end
            context 'when context contains no alias field' do
              before { node.sorting_attributes = { score: :asc, price: :desc }}
              it 'should return serialized sort attributes' do
                expect(node.compile).to eq "score asc,price desc"
              end
            end
          end
          context 'with empty sorting attributes' do
            it 'should return nil' do
              expect(node.compile).to eq nil
            end
          end
        end

      end
    end
  end
end
