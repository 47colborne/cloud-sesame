module CloudSesame
	module Query
		module AST
			describe RangeValue do

				let(:type) { nil }
				subject { RangeValue.new(initial_value, type) }

				describe '#initialize' do

					shared_examples 'determine lower bound, begin, end' do
						it 'should determine the lower bound' do
							expect(subject.lower_bound).to eq lower_bound
						end
						it 'should determine the begin value' do
							expect(subject.begin).to eq start_value
						end
						it 'should determine the end value' do
							expect(subject.end).to eq end_value
						end
						it 'should determine the upper bound' do
							expect(subject.upper_bound).to eq upper_bound
						end
					end

					shared_examples 'possible upper bound' do
						context 'when upper bound is included' do
							let(:upper_bound) { ']' }
							include_examples 'determine lower bound, begin, end'
						end
						context 'when upper bound is excluded' do
							let(:upper_bound) { '}' }
							include_examples 'determine lower bound, begin, end'
						end
					end

					context 'when given a ruby range object' do
						let(:start_value) { 10 }
						let(:end_value) { 20 }

						let(:lower_bound) { '[' }
						context 'when upper bound is included' do
							let(:upper_bound) { ']' }
							let(:initial_value) { start_value..end_value }
							include_examples 'determine lower bound, begin, end'
						end
						context 'when lower bound is excluded' do
							let(:initial_value) { start_value...end_value }
							let(:upper_bound) { '}' }
							include_examples 'determine lower bound, begin, end'
						end
					end

					context 'when given a aws range string' do
						let(:start_value) { "10" }
						let(:end_value) { "20" }
						let(:initial_value) { "#{ lower_bound }#{ start_value },#{ end_value }#{ upper_bound }" }

						context 'when lower bound is included' do
							let(:lower_bound) { '[' }
							include_examples 'possible upper bound'
						end
						context 'when lower bound is excluded' do
							let(:lower_bound) { '{' }
							include_examples 'possible upper bound'
						end
					end

					context 'when given no initial value' do
						let(:initial_value) { nil }
						let(:lower_bound) { "{" }
						let(:upper_bound) { "}" }
						let(:start_value) { nil }
						let(:end_value) { nil }
						include_examples 'determine lower bound, begin, end'
					end

					context 'when given type' do
						let(:start_value) { 10 }
						let(:end_value) { 20 }
						let(:initial_value) { start_value..end_value }
						let(:type) { Value }
						it 'should parse the start and end value with type' do
							expect(type).to receive(:parse).with(end_value)
							expect(type).to receive(:parse).with(start_value)
							subject
						end
						it 'should convert start and end value to value object' do
							expect(subject.begin).to be_kind_of(Abstract::Value)
							expect(subject.end).to be_kind_of(Abstract::Value)
						end
					end

					context 'when given no type' do
						let(:initial_value) { 10..20 }

						# it 'should not parse the start and end value' do
						# 	expect(type).to_not receive(:parse)
						# 	subject
						# end
						it 'should keep the original start and end value' do
							expect(subject.begin).to be_kind_of(Numeric)
							expect(subject.end).to be_kind_of(Numeric)
						end
					end

				end

				describe '#parse' do
					let(:begin_value) { 1 }
		  		let(:end_value) { 10 }
					let(:initial_value) { begin_value..end_value }

					it 'should return self' do
						expect(subject.parse(nil)).to eq subject
					end

				  context 'given type and type respond to parse' do
				  	let(:parse_type) { Value }

				  	context 'and begin and end value is not empty in string form' do
							it 'should parse the begin and end value' do
								expect(parse_type).to receive(:parse).with(end_value)
								expect(parse_type).to receive(:parse).with(begin_value)
								subject.parse(parse_type)
							end
				  	end
				  	context 'and begin and end value is empty in string form' do
							let(:begin_value) { nil }
				  		let(:end_value) { nil }

				  		it 'should not try to parse the begin and end value' do
				  			expect(parse_type).to_not receive(:parse)
				  			subject.parse(parse_type)
				  		end
				  	end
				  end
				  context 'given type does not respond to parse' do
						let(:parse_type) { "Random Type" }
						before { allow(parse_type).to receive(:respond_to?).and_return(false) }
						it 'should not try to parse the begin and end value' do
							expect(parse_type).to_not receive(:parse)
							subject.parse(parse_type)
						end
				  end
				  # context 'given type is nil' do
						# let(:parse_type) { nil }
						# it 'should not try to parse the begin and end value' do
						# 	expect(parse_type).to_not receive(:parse)
						# 	subject.parse(parse_type)
						# end
				  # end
				end

				describe '#begin' do
					let(:begin_value) { 1 }
					let(:end_value) { 10 }
					let(:initial_value) { begin_value..end_value }
					it 'should return the begin value' do
						expect(subject.begin).to eq begin_value
					end
				end

				describe '#end' do
					let(:begin_value) { 1 }
					let(:end_value) { 10 }
					let(:initial_value) { begin_value..end_value }
					it 'should return the end value' do
						expect(subject.end).to eq end_value
					end
				end

				describe '#lower_bound' do
					let(:lower_bound) { "{" }
					let(:upper_bound) { "}" }
					let(:begin_value) { "1" }
					let(:end_value) { "10" }
					let(:initial_value) { lower_bound + begin_value + ',' + end_value + upper_bound }
					it 'should return the lower bound symbol' do
						expect(subject.lower_bound).to eq lower_bound
					end
				end

				describe '#upper_bound' do
					let(:lower_bound) { "{" }
					let(:upper_bound) { "}" }
					let(:begin_value) { "1" }
					let(:end_value) { "10" }
					let(:initial_value) { lower_bound + begin_value + ',' + end_value + upper_bound }
					it 'should return the upper bound symbol' do
						expect(subject.upper_bound).to eq upper_bound
					end
				end

				describe '#gt' do
					let(:value) { 100 }
					let(:initial_value) { nil }
					it 'should set the begin value' do
						expect{ subject.gt(value) }.to change{ subject.begin }.from(nil).to(value)
					end
					it 'should set the lower bound to be excluded' do
						subject.gt(value)
						expect(subject.lower_bound).to eq '{'
					end
				end

				describe '#gte' do
					let(:value) { 101 }
					let(:initial_value) { nil }
					it 'should set the begin value' do
						expect{ subject.gte(value) }.to change{ subject.begin }.from(nil).to(value)
					end
					it 'should set the lower bound to be excluded' do
						subject.gte(value)
						expect(subject.lower_bound).to eq '['
					end
				end

				describe '#lt' do
					let(:value) { 100 }
					let(:initial_value) { nil }
					it 'should set the begin value' do
						expect{ subject.lt(value) }.to change{ subject.end }.from(nil).to(value)
					end
					it 'should set the lower bound to be excluded' do
						subject.lt(value)
						expect(subject.upper_bound).to eq '}'
					end
				end

				describe '#lte' do
					let(:value) { 100 }
					let(:initial_value) { nil }
					it 'should set the begin value' do
						expect{ subject.lte(value) }.to change{ subject.end }.from(nil).to(value)
					end
					it 'should set the lower bound to be excluded' do
						subject.lte(value)
						expect(subject.upper_bound).to eq ']'
					end
				end

				describe '#to_s' do
					let(:initial_value) { 10..255 }
					it 'should return the compiled value' do
						expect(subject.to_s).to eq subject.compile
					end
				end

				describe '#==' do
					let(:initial_value) { 10...255 }
					let(:object) { "[10,255}" }
				  it 'should convert the object comparing with to RangeValue' do
				  	subject
						expect(RangeValue).to receive(:new).with(object, Value).and_call_original
						subject == object
				  end
				  it 'should return true when the parsed value are the same' do
						expect(subject == object).to eq true
				  end
					it 'should return false when the parsed value is different' do
						expect(subject == (10..255)).to eq false
					end
				end

			end
		end
	end
end
