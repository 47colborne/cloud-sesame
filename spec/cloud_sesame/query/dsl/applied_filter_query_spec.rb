module CloudSesame
  module Query
    module DSL

      shared_examples AppliedFilterQuery do

        let(:applied_field) { :applied }
        let(:applied_value) { :value }
        let(:included) { true }

        let(:not_applied_field) { :not_applied }
        let(:not_applied_value) { :not_applied_value }

        describe '#applied_filters' do

          let(:applied) {[{
            field: :field1,
            value: :value1,
            included: true
          }, {
            field: :field1,
            value: :value2,
            included: false
            }, {
            field: :field2,
            value: :value2,
            included: false
          }]}

          before { allow(subject.send(:_scope)).to receive(:applied).and_return(applied) }

          it 'should call _scope and ask for applied' do
            expect(subject.send(:_scope)).to receive(:applied).and_return(applied)
            subject.applied_filters
          end
          context 'when included is nil' do
            let(:included) { nil }
            it 'should include all field applied' do
              expect(subject.applied_filters(included).values.flatten.size).to eq(3)
            end
          end
          context 'when included is TRUE' do
            let(:included) { true }
            it 'should include only the included fields' do
              expect(subject.applied_filters(included).values.flatten.size).to eq(1)
            end
          end
          context 'when included is FALSE' do
            let(:included) { false }
            it 'should include only the excluded fields' do
              expect(subject.applied_filters(included).values.flatten.size).to eq(2)
            end
          end
        end

        describe '#included?' do
          it 'should call #applied? with included set to TRUE and alone with the field and value' do
            expect(subject).to receive(:applied?).with(applied_field, applied_value, included)
            subject.included?(applied_field, applied_value)
          end
        end

        describe '#excluded?' do
          let(:field) { :field }
          let(:value) { :value }
          it 'should call #applied? with included set to FALSE and alone with the field and value' do
            expect(subject).to receive(:applied?).with(field, value, false)
            subject.excluded?(field, value)
          end
        end

        describe '#applied?' do

          let(:applied) {[{
            field: applied_field,
            value: applied_value,
            included: included
          }]}

          before { allow(subject.send(:_scope)).to receive(:applied).and_return(applied) }

          it 'should call #applied_filters with included' do
            expect(subject).to receive(:applied_filters).with(included).and_call_original
            subject.applied?(applied_field, applied_value, included)
          end

          context 'when value is nil' do
            it 'should return true when applied_filters include the field' do
              expect(subject.applied?(applied_field)).to eq true
            end
            it 'should return false when applied_filters not include the field' do
              expect(subject.applied?(not_applied_field)).to eq false
            end
          end
          context 'when value is present' do
            it 'should return true when applied_filters include the field and value' do
              expect(subject.applied?(applied_field, applied_value)).to eq true
            end
            it 'should return false when applied_filters not include the field and value' do
              expect(subject.applied?(applied_field, not_applied_value)).to eq false
            end
          end

        end


      end
    end
  end
end
