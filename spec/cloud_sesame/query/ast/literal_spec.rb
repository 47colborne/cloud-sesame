module CloudSesame
  module Query
    module AST
      describe Literal do

        let(:field) { :literal }
        let(:value) { "value" }
        let(:options) { {} }
        subject { Literal.new(field, value, options) }

        describe '#initialize' do
          context 'when the value is given' do

            it 'should create an lazy object' do
              expect(LazyObject).to receive(:new)
              subject
            end

            context 'and the options contains field type' do
              let(:field_type) { class_double(Value) }
              let(:options) {{ type: field_type }}
              before { allow(LazyObject).to receive(:new) { |&b| b.call } }

              it 'should parse value with field type inside the lazy object' do
                expect(field_type).to receive(:parse).with(value)
                subject
              end
            end

            context 'and the options does not contain type' do
              before { allow(LazyObject).to receive(:new) { |&b| b.call } }

              it 'should create a lazy object' do
                expect(Value).to receive(:parse).with(value)
                subject
              end
            end

          end

          context 'when the value is nil' do
            let(:value) { nil }
            it 'should not parse the value using lazy object' do
              expect(LazyObject).to_not receive(:new)
              subject
            end
          end

          context 'when the options is nil' do
            let(:options) { nil }
            it 'should use the default options' do
              expect(subject.options).to eq({ type: Value })
            end
          end
        end

        describe '#applied' do
          let(:included) { true }
          context 'when value is given' do
            it 'should return an hash contains field value and included' do
              expect(subject.applied(included)).to include(
                field: field,
                value: value,
                included: included
              )
            end
          end
          context 'when value is not given' do
            let(:value) { nil }
            it 'should return nothing' do
              expect(subject.applied(included)).to be_nil
            end
          end
        end

        describe '#actual_field_name' do
          context 'when options contains :as value' do
            let(:actual_field_name) { :field1 }
            let(:options) { { as: actual_field_name } }
            it 'should use the :as value as the actual field name' do
              expect(subject.actual_field_name).to eq actual_field_name
            end
          end
          context 'when options does not contain :as value' do
            it 'should use the field as the actual field name' do
              expect(subject.actual_field_name).to eq field
            end
          end
        end

        # (detailed ? detailed_format : standard_format) if @value
        describe '#compile' do
          context 'when value is not present' do
            let(:value) { nil }
            it 'should return nothing' do
              expect(subject.compile).to be_nil
            end
          end
          context 'when value is present' do
            it 'should compile the value' do
              expect(subject.value).to receive(:compile)
              subject.compile
            end
            it 'should compile into standard format by default' do
              expect(subject.compile).to eq "#{ field }:#{ subject.value.compile }"
            end
          end
          context 'when request detailed format' do
            it 'should compile into detailed format' do
              expect(subject.compile(true)).to eq("field='#{ field }' #{ subject.value.compile }")
            end
          end
        end

        describe '#is_for' do
          let(:new_field) { :new_literal }
          it 'should set the field' do
            expect{ subject.is_for(new_field, nil) }.to change{ subject.field }.from(field).to(new_field)
          end
          context 'when options is present' do
            let(:options) { { old: "value" } }
            let(:new_options) { { new: "new value" } }
            it 'should take the options and merge with existing options' do
              expect{ subject.is_for(field, new_options) }.to change{ subject.options }.from(options.clone).to(options.merge(new_options))
            end
          end
          context 'when options is not present' do
            it 'should do nothing with the existing options' do
              expect{ subject.is_for(field, nil) }.to_not change{ subject.options }
            end
          end
        end

      end
    end
  end
end
