require 'spec_helper'

module CloudSearch
  module Query
    module Node
      describe Sort do

        let(:arguments) {{ }}
        let(:node) { Sort.new(arguments) }

        describe '#initialize' do
          context 'when arguments passed in' do
            let(:arguments) {{ sort: "score asc,price desc" }}
            it 'should accept sort argument and initialize sorting_attributes' do
              expect(node.sorting_attributes).to eq({ score: :asc, price: :desc })
            end
            it 'should initialize an empty sorting_attributes when arguments sort is empty' do
              arguments[:sort] = ""
              expect(node.sorting_attributes).to eq({ })
            end
          end
          context 'when arguments not passed in' do
            it 'should initialize an empty sorting_attributes' do
              expect(node.sorting_attributes).to eq({ })
            end
          end
        end

        describe '#[]' do
          context 'with existing attribute' do
            let(:arguments) {{ sort: "score asc,price desc" }}
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
            let(:arguments) {{ sort: "score asc,price desc" }}
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

        describe '#run' do
          context 'with existing sorting attributes' do
            let(:arguments) {{ sort: "score asc,price desc" }}
            it 'should return a hash with serialized sort attributes' do
              expect(node.compile).to eq arguments
            end
          end
          context 'with empty sorting attributes' do
            it 'should return a hash with empty sort' do
              expect(node.compile).to eq({ sort: "" })
            end
          end
        end

      end
    end
  end
end
