require 'spec_helper'

describe AbstractObject do

	# define TestConfig Class
	class TestConfig < AbstractObject; end

	describe '.accept' do
		before { TestConfig.accept :access_key }

		it 'should define attribute accessor using attribute name' do
			expect(TestConfig.new).to respond_to(:access_key, :access_key=)
		end

		it 'should store attribute name in definitions' do
			definitions = TestConfig.instance_variable_get(:@definitions)
			expect(definitions).to include(access_key: :access_key)
		end

		context 'when accept attribute aliases' do
			before { TestConfig.accept :access_key, as: [:access_key_id] }

			it 'should define attribute accessor using default attribute name' do
				expect(TestConfig.new).to respond_to(:access_key, :access_key=)
			end
			it 'should define attribute accessor using aliases' do
				expect(TestConfig.new).to respond_to(:access_key_id, :access_key_id=)
			end
			it 'should store aliases in definitions' do
				definitions = TestConfig.instance_variable_get(:@definitions)
				expect(definitions).to include(access_key: :access_key, access_key_id: :access_key)
			end
		end

		context 'when accept attribute with default value' do
			let(:default_value) { SecureRandom.hex }
			before { TestConfig.accept :access_key, default: default_value }

			it 'should return default value if attribute hasn\'t being set' do
				expect(TestConfig.new.access_key).to eq default_value
			end
		end

	end

	describe '#initialize' do

		shared_examples 'acceptable attributes' do
			it 'should set the acceptable attributes' do
				expect(TestConfig.new(attributes_passed_in).to_hash).to include attributes_accepted
			end
		end

		shared_examples 'unacceptable attributes' do
			it 'should filter out the unacceptable attributes' do
				expect(TestConfig.new(attributes_passed_in).to_hash).to_not include attributes_not_accepted
			end
		end

		context 'when attributes passed is a hash' do
			let(:attributes_accepted) { { access_key: 1 } }

			context 'and attribute name is used' do
				let(:attributes_passed_in) { { access_key: 1 } }
				include_examples 'acceptable attributes'
			end

			context 'and attribute alias is used' do
				let(:attributes_passed_in) { { access_key_id: 1 } }
				include_examples 'acceptable attributes'
			end

			context 'and attribute is not in the definitions' do
				let(:attributes_not_accepted) { { secret_key: 2 } }
				let(:attributes_passed_in) { { secret_key: 2 } }
				include_examples 'unacceptable attributes'
			end


		end
		context 'when attributes passed is a config object' do
			let(:attributes_accepted) { { access_key: 1 } }
			let(:attributes_not_accepted) { { secret_key: 2 } }
			let(:attributes_passed_in) { TestConfig.new(access_key: 1, secret_key: 2) }
			include_examples 'acceptable attributes'
			include_examples 'unacceptable attributes'
		end
	end

	describe 'to_hash' do
		let(:config) { TestConfig.new(access_key: 1) }

		it 'should return config attributes in hash' do
			expect(config.to_hash).to be_a(Hash)
		end

		it 'should not be able to manipulate the config through the hash' do
			config.to_hash[:secret_key] = 2
			expect(config.to_hash).to_not include(secret_key: 2)
		end
	end

end
