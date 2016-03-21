module CloudSesame
  module Query
    module AST
      describe Not do

        let(:context) {{}}
        subject { Not.new(context) }

        it 'should be a type of operator' do
          expect(Not.ancestors).to include(Abstract::SingleExpressionOperator)
        end

        it 'should have symbol :not' do
          expect(Not::SYMBOL).to eq :not
        end

        describe '#applied' do
          let(:included) { false }
          let(:child) { instance_double(Abstract::SingleExpressionOperator) }
          before { subject << child }
          it 'should inverse included and broadcast to it\'s child' do
            expect(child).to receive(:applied).with(!included)
            subject.applied(included)
          end
        end

      end
    end
  end
end
