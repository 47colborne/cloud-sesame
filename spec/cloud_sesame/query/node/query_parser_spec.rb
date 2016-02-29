require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe QueryParser do
        let(:context) { {} }
        subject { QueryParser.new(context) }

        describe 'type accessors' do
          it 'should set the type' do
            expect{ subject.structured }.to change{ subject.type }.from('simple').to('structured')
          end
        end

        describe '#type' do
          it 'should default to simple if not passed in from context' do
            expect(subject.type).to eq('simple')
          end
        end

        describe '#compile' do
          it 'should return a hash with query_parser type' do
            expect(subject.compile).to eq 'simple'
          end
        end

      end
    end
  end
end
