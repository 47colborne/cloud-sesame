require "spec_helper"

module CloudSesame
  module Query
    module AST
      describe MultiExpressionOperator do
        let(:proc) { Proc.new {} }
        let(:operator) { MultiExpressionOperator.new({}, &proc )}
        before { MultiExpressionOperator.symbol = :symbol }

        describe '#compile' do

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
