module CloudSesame
  module Query
    module AST
      describe And do

        it 'should be a type of operator' do
          expect(And.ancestors).to include(MultiExpressionOperator)
        end

        it 'should have symbol :and' do
          expect(And::SYMBOL).to eq :and
        end

      end
    end
  end
end
