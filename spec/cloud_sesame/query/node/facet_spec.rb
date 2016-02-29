require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe Facet do
        let(:facet) { Facet.new(facet_options) }

        describe '#compile' do
          context 'when facet is not empty' do
            let(:facet_options) { { price: { size: 100 } } }
            it 'should return stringified JSON facet' do
              expect(facet.compile).to eq JSON.dump(facet_options)
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
