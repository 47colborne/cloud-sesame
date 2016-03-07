module CloudSesame
	module Query
		module DSL

			describe FieldAccessors do
				let(:test_class) { Class.new { include FieldAccessors } }
				describe '.__define_accessor__' do
					let(:name) { :test_name }
					it 'should define a instance method with the given name' do
						expect{ FieldAccessors.__define_accessor__(name) }.to change{ FieldAccessors.instance_methods }.by([name])
					end
					it 'should defined a method who triggers #literal when gets called' do
						test = test_class.new
						values = [1, 2, 3]
						expect(test).to receive(:literal).with(name, *values)
						test.send(name, *values)
					end
				end
			end

			shared_examples_for 'FieldAccessors' do
				let(:field_name) { :test_field_name }
				let(:_scope) { subject.send(:_scope) }
				let(:context) { { fields: { field_name => {} } } }
				let(:_return) { subject.send(:_return) }
				let(:options) { context[:fields][field_name] }

				before { allow(_scope).to receive(:context).and_return(context) }

				describe '#literal' do

					it 'should tell the scope children what field is it for' do
						expect(subject.send(:_scope).children).to receive(:field=).with(field_name)
						subject.literal(field_name)
					end

					it 'should tell the scope children what to return' do
						allow(subject).to receive(:_return).and_return(_return)
						expect(subject.send(:_scope).children).to receive(:_return=).with(_return)
						subject.literal(field_name)
					end

					it 'should insert all the values into the children' do
						values = [1, 2, 3, 4, 5]
						expect(subject.send(:_scope).children).to receive(:insert).with(values)
						subject.literal(field_name, *values)
					end

					context 'given a block' do
						let(:block) { Proc.new { "1" } }
						let(:caller) { self }

						it 'should evalute the block with Domain::Literal' do
							domain = Domain::Literal.new(field_name, options, caller)
							expect(Domain::Literal).to receive(:new).with(field_name, options, self).and_return(domain)
							expect(domain).to receive(:_eval) do |&received_block|
								received_block == block
							end
							subject.literal(field_name, &block)
						end

						it 'should add the evaluated value to values' do
							expect(subject.send(:_scope).children).to receive(:insert).with(include(AST::Literal))
							subject.literal(field_name, &block)

						end
					end

				end

				context 'when field is registered' do
					before(:all) { FieldAccessors.__define_accessor__(:test_field_name) }
					let(:value) { "value" }

					it 'should create a literal node' do
						expect(AST::Literal).to receive(:new).with(field_name, value, options)
						subject.send(field_name, value)
					end
					it 'should belong to the dsl context' do
						expect{ subject.send(field_name, value) }.to change{ subject.request.filter_query.root.children.size }.by(1)
					end
					it 'should return the dsl scope if called from the root' do
						expect(subject.send(field_name, value)).to eq subject
					end

					it 'should return the field array if called from inside a block' do
						array = nil
						subject.and { array = send(field_name, value) }
						expect(array).to be_kind_of(AST::FieldArray)
						expect(array).to include(AST::Literal)
					end
					it 'should set the field array#field' do
						array = nil
						subject.and { array = send(field_name, value)  }
						expect(array.field).to eq field_name
					end
				end

				context 'when field is not registered' do
					it 'should raise an error' do
						expect{ subject.unregistered("description") }.to raise_error NoMethodError
					end
				end

			end
		end
	end
end
