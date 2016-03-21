module CloudSesame
  module Query
    module AST
      describe Phrase do
        it 'should be a type of operator' do
          expect(Phrase.ancestors).to include(Abstract::SingleExpressionOperator)
        end

        it 'should have symbol :term' do
          expect(Phrase::SYMBOL).to eq :phrase
        end

        it 'should be set to detailed' do
          expect(Phrase::DETAILED).to eq true
        end

      end
    end
  end
end
