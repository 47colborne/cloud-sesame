module CloudSesame
  module Query
    module AST
      describe Or do

        it 'should be a type of operator' do
          expect(Or.ancestors).to include(MultiExpressionOperator)
        end

        it 'should have symbol :or' do
          expect(Or::SYMBOL).to eq :or
        end

      end
    end
  end
end
