require 'spec_helper'

module CloudSesame
	module Query
		module DSL
			describe FieldArrayMethods do

				# Setup Test Class
				class Product
					include CloudSesame
					define_cloudsearch {
						field :name
						field :tags
					}
				end

				subject(:cloudsearch) { Product.cloudsearch }

				after { subject.clear_request }

				shared_examples_for 'single_expression_operator' do |command, klass, operator_weight|

					it "should insert the class Near into parents at index #{ operator_weight }" do
						array = nil
						subject.and { array = tags.send(command) }
						expect(array.parents[operator_weight]).to eq klass
					end

					context 'when given values' do
						let(:array) {
							array = nil
							subject.and { array = tags.send(command, "men") }
							array
						}

						it 'should create a literal node with the value' do
							expect(AST::Literal).to receive(:new).with(:tags, "men", Hash).and_call_original
							array
						end
						it 'should create a near node' do
							expect(klass).to receive(:new).and_call_original
							array
						end
						it 'should set the literal node to near node child' do
							expect(array.first.child).to be_kind_of(AST::Literal)
							expect(array.first.child.value).to eq "men"
						end
						it 'should insert the near node to itself' do
							expect(array).to include(klass)
						end
					end
				end

				describe '#near' do
					it_should_behave_like "single_expression_operator", :near, AST::Near, 1
				end

				describe '#prefix' do
					it_should_behave_like "single_expression_operator", :prefix, AST::Prefix, 1
				end

				describe '#not' do
					it_should_behave_like "single_expression_operator", :not, AST::Not, 0
				end

			end
		end
	end
end
