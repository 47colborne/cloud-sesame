require "spec_helper"

module CloudSearch
  module Query
    module AST
      describe And do
        it 'should set the symbol to :and' do
          expect(And.symbol).to eq :and
        end
      end
    end
  end
end
