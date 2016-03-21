module CloudSesame
  module Query
    module AST
      describe Term do
        it 'should be a type of operator' do
          expect(Term.ancestors).to include(Abstract::SingleExpressionOperator)
        end

        it 'should have symbol :term' do
          expect(Term::SYMBOL).to eq :term
        end

        it 'should be set to detailed' do
          expect(Term::DETAILED).to eq true
        end

      end
    end
  end
end
