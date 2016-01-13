require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe Facet do
        let(:facet) { Facet.new(context) }
        let(:context) { Domain::Context.new(facet_options) }
        describe '#facet' do
          context 'when default facet is defined' do
            let(:facet_options) { { price: { size: 100 } } }
            it 'should return the default facet options' do
              expect(facet.facet).to include(facet_options)
            end
          end
          context 'when default facet is not defined' do
            let(:facet_options) { {} }
            it 'should return an empty facet options' do
              expect(facet.facet).to include(facet_options)
            end
          end
        end

        describe '#compile' do
          context 'when facet is not empty' do
            let(:facet_options) { { price: { size: 100 } } }
            it 'should return stringified JSON facet' do
              expect(facet.compile).to include facet: JSON.dump(facet_options)
            end
          end
          context 'when facet is empty' do
            let(:facet_options) { { } }
            it 'should return nil' do
              expect(facet.compile).to eq nil
            end
          end
        end

      end
    end
  end
end