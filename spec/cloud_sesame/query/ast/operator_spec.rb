require 'spec_helper'

module CloudSesame
  module Query
    module AST
      describe Operator do
        let(:context) {{}}
        let(:options) {{}}
        let(:block) { Proc.new {} }
        subject { Operator.new(context, options, &block) }

        describe '#initialize' do
          context 'given a block' do
            let(:block) { Proc.new { context[:name] = :test } }
            it 'should evalute the block' do
              expect(subject.context[:name]).to eq :test
            end
          end
        end

        describe '#boost' do
          context 'given boost option' do
            let(:options) {{ boost: 2 }}
            it 'should return an compiled boost value' do
              expect(subject.boost).to eq " boost=2"
            end
          end
          context 'given no boost option' do
            it 'should return nothing' do
              expect(subject.boost).to eq nil
            end
          end
        end

      end
    end
  end
end
