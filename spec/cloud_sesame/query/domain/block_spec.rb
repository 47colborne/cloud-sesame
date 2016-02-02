module CloudSesame
	module Query
		module Domain
			describe Block do

				class Caller

					def initialize
						@test = "hello"
					end

					def test_method
						return "test method!!!"
					end
				end

				subject { Block.new(Caller.new, {}) }

				# expect modules to be included
				[
					DSL::BlockStyledOperators,
					DSL::FieldAccessors,
					DSL::ScopeAccessors,
					DSL::Operators,
					DSL::BindCaller
				].each do |included_module|
					it "should include #{ included_module }" do
						expect(Block.included_modules).to include included_module
					end
				end

				context 'given a caller' do

					it 'should have access to caller\'s instance variables' do
						expect(subject.instance_variable_get(:@test)).to eq "hello"
					end

					it 'should have access to caller\'s methods' do
						expect(subject.test_method).to eq "test method!!!"
					end

				end

				describe '#_scopes' do
					it 'should be default to an empty array' do
						expect(subject._scopes).to eq []
					end
					it 'should not be able to get overrided' do
						expect{ subject._scopes = [] }.to raise_error(NoMethodError)
					end
				end

				describe '#_scope' do
					context 'when scopes is not empty' do
						before { subject._scopes << 1 << 2 }
						it 'should return the last item from _scopes' do
							expect(subject._scope).to eq 2
						end
					end
					context 'when scopes is empty' do
						it 'should return nil' do
							expect(subject._scope).to eq nil
						end
					end
				end

				# def _eval(node, _scope, _return = _scope, &block)
				# 	_scopes.push node
				# 	instance_eval &block
				# 	_scope << node
				# 	_scopes.pop
				# 	_scope.is_a?(AST::Root) ? _return : node
				# end
				describe '#_eval' do

					let(:node) { AST::And.new({}, {}) }
					let(:scope) { AST::And.new({}, {}) }

					context 'when block is not given' do
						it 'should raise an error ' do
							expect{ subject._eval(node, scope) }.to raise_error(ArgumentError)
						end
					end

					context 'when a block is given' do

						subject { Block.new(self, {}) }

						it 'should use itself to evalute the block' do
							subject._eval(node, scope) { expect(self).to eq subject }
						end

						it 'should change the _scope in the block to the node passed in' do
							subject._eval(node, scope) { expect(_scope).to eq node }
						end

						it 'should set the _scope back to previous scope after _eval' do
							subject._scopes << :first_scope
							subject._eval(node, scope) {}
							expect(subject._scope).to eq :first_scope
						end

						context 'when _scope is not a root node' do
							it 'should return the node it self' do
								expect(subject._eval(node, scope) {}).to eq node
							end
						end

						context 'when _scope is a root node' do
							it 'should return the _return' do
								scope = AST::Root.new({}, {})
								expect(subject._eval(node, scope, :return_object) { }).to eq :return_object
							end
						end

					end


				end

			end
		end
	end
end
