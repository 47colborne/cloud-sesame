require 'spec_helper'

module CloudSesame
	module Query
		module DSL
			describe FieldMethods do

				# Setup Test Class
				class Product
					include CloudSesame
					define_cloudsearch {
						field :name
						field :tags
					}
				end

				subject(:cloudsearch) { Product.cloudsearch.builder }

				after { subject.clear_request }

				context 'when field is registered' do
					it 'should create a literal node' do
						expect(AST::Literal).to receive(:new).with(:name, "my name", {})
						subject.name "my name"
					end
					it 'should belong to the dsl context' do
						expect{ subject.name "name" }.to change{ subject.request.filter_query.root.children.size }.by(1)
					end
					it 'should return the dsl scope if called from the root' do
						expect(subject.tags "men").to eq subject
					end
					it 'should return the field array if called from inside a block' do
						array = nil
						subject.and { array = tags("men") }
						expect(array).to be_kind_of(AST::FieldArray)
						expect(array).to include(AST::Literal)
					end
					it 'shoudl set the field array#field' do
						array = nil
						subject.and { array = tags("men") }
						expect(array.field).to eq :tags
					end
				end

				context 'when field is not registered' do
					it 'should raise an error' do
						expect{ subject.description("description") }.to raise_error NoMethodError
					end
				end

			end
		end
	end
end
