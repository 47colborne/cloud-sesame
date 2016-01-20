require 'spec_helper'

module CloudSesame
	module Query
		module DSL
			describe BlockChainingMethods do

				# Setup Test Class
				class Product
					include CloudSesame
					define_cloudsearch {}
				end

				subject(:cloudsearch) { Product.cloudsearch.builder }

				after { subject.clear_request }

				# NOT
				# =======================================
				describe '#not' do
					let(:node_class) { AST::Not }

					context 'when not called after an operator' do
						it 'should raise an error' do
							expect{ subject.not }.to raise_error NoMethodError
						end
					end
					context 'when called after an multi expression operator method call' do
						context 'and not block is given' do
							it 'should raise an error' do
								expect{ subject.or.not }.to raise_error Error::InvalidSyntax
							end
						end
						context 'and block is given' do
							it 'should create a NOT node' do
								expect(node_class).to receive(:new).and_call_original
								subject.and.not {}
							end
							it 'should have the operator node as child' do
								subject.and.not {}
								expect(subject.request.filter_query.root.children[0].child ).to be_kind_of(AST::And)
							end
							it 'should belong to the dsl scope' do
								expect{ subject.and.not {} }.to change{ subject.request.filter_query.root.children[0] }.from(nil).to be_kind_of(node_class)
							end
							context 'from root' do
								it 'should return the cloudsearch domain' do
									expect(subject.and.not {}).to eq subject
								end
							end
							context 'from inside of nested block' do
								it 'should return the Not node itself' do
									node = nil
									subject.and { node = or!.not {} }
									expect(node).to be_kind_of(node_class)
								end
							end
						end
					end

				end

			end
		end
	end
end
