require "spec_helper"

module CloudSearch
  module Query
    module AST
      describe Or do
        it 'should set the symbol to :or' do
          expect(Or.symbol).to eq :or
        end
      end
    end
  end
end
