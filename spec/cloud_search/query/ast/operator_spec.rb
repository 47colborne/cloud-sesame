require "spec_helper"

module CloudSearch
  module Query
    module AST
      describe Operator do
        let(:proc) { Proc.new {} }
        let(:operator) { Operator.new({}, &proc )}
        before { Operator.symbol = :symbol }

        describe '#compile' do
          it 'should raise an error if operator symbol has not being set' do
            Operator.symbol = nil
            expect{ operator.compile }.to raise_error(Error::MissingOperatorSymbol)
          end

          it 'should return nil if children are empty' do
            expect(operator.compile).to eq(nil)
          end

          it 'should return a string with the symbol and compile children' do
            operator.children.push Literal.new(:price, 10)
            expect(operator.compile).to eq("(symbol price:10)")
          end

        end
      end
    end
  end
end
