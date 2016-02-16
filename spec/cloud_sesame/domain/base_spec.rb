module CloudSesame
  module Domain
    describe Base do

      class BaseSearchable; end

      let(:searchable) { BaseSearchable }
      subject { Base.new(searchable) }

      shared_examples 'delegation to client' do |method|
        it 'should be delegated to #client' do
          expect(subject.client).to receive(method)
          subject.send(method)
        end
      end

      describe '#config' do
        it_behaves_like 'delegation to client', :config
      end

      describe '#caching_with' do
        it_behaves_like 'delegation to client', :caching_with
      end

      describe '#builder' do
        it 'should initialize an new builder each time' do
          number = 2
          expect(Query::Builder).to receive(:new).exactly(number).times.and_call_original
          number.times { subject.builder }
        end
        it 'should receive the context from base when called' do
          c = Context.new
          expect(subject).to receive(:context).and_return(c)
          subject.builder
        end
        it 'should receive the searchable form base when called' do
          expect(subject).to receive(:searchable).and_return(searchable)
          subject.builder
        end
      end

      describe '#client' do
        it 'should initialize and return a domain client with searchable' do
          expect(Client).to receive(:new).with(searchable)
          subject.client
        end
      end

      describe '#context' do
        it 'should initialize and return a context' do
          expect(Context).to receive(:new)
          subject.context
        end
      end

      describe '#default_size' do
        it 'should store the value to context page size' do
          size = 99
          subject.default_size size
          expect(subject.context[:page][:size]).to eq(size)
        end
        it 'should convert value to integer' do
          size = "99"
          subject.default_size size
          expect(subject.context[:page][:size]).to eq(size.to_i)
        end
        it 'should add page size to context' do
          expect{ subject.default_size 99 }.to change{ subject.context[:page] }.from(nil).to(hash_including(size: 99))
        end
      end

      describe '#define_sloppiness' do
        it 'should create a sloppiness node' do
          value = 3
          expect(Query::Node::Sloppiness).to receive(:new).with(value)
          subject.define_sloppiness(value)
        end
        it 'should add query sloppiness to context' do
          expect{ subject.define_sloppiness 3 }.to change{ subject.context[:query] }.from(nil).to(hash_including(sloppiness: Query::Node::Sloppiness))
        end
      end

      describe '#define_fuzziness' do
        let(:block) { Proc.new {} }
        it 'should create a fuzziness node' do
          expect(Query::Node::Fuzziness).to receive(:new) { |&b|
            expect(b).to eq block
          }
          subject.define_fuzziness(&block)
        end
        it 'should add query fuzziness to context' do
          expect{ subject.define_fuzziness {} }.to change{ subject.context[:query] }.from(nil).to(hash_including(fuzziness: Query::Node::Fuzziness))
        end
      end

      describe '#field' do
        let(:field_name) { :name }

        shared_examples 'and options :as is also passed' do
          let(:real_name) { :text1 }
          before { options[:as] = real_name }
          it 'should use the real name as field name' do
            subject.field field_name, options
            expect(custom_options).to include(real_name)
          end
        end

        context 'when options :query is passed in' do
          let(:options) { { query: true } }

          context 'and query is set to true' do
            it 'should add query options for field' do
              subject.field(field_name, options)
              expect(subject.context[:query_options][:fields][field_name]).to eq({})
            end
          end
          context 'and query has options' do
            it 'should use the query options for field' do
              query_options = { weight: 2 }
              options[:query] = query_options
              subject.field(field_name, options)
              expect(subject.context[:query_options][:fields][field_name]).to eq(query_options)
            end
          end

          it_behaves_like 'and options :as is also passed' do
            let(:options) { { query: true } }
            let(:custom_options) { subject.context[:query_options][:fields] }
          end
        end

        context 'when options :facet is passed in' do
          let(:options) {{ facet: true }}
          context 'and facet is set to true' do
            it 'should add facet options for field' do
              subject.field(field_name, options)
              expect(subject.context[:facet][field_name]).to eq({})
            end
          end
          context 'and facet has options' do
            it 'should use the facet options defined' do
              facet_options = { size: 2 }
              options[:facet] = facet_options
              subject.field(field_name, options)
              expect(subject.context[:facet][field_name]).to eq(facet_options)
            end
          end

          it_behaves_like 'and options :as is also passed' do
            let(:options) { { facet: true } }
            let(:custom_options) { subject.context[:facet] }
          end
        end

        context 'when options :as is passed in' do
          let(:options) {{ override: false }}
          context 'and filter_query fields contains an options for field :as' do
            let(:original_option) {{ hello: 'world', override: true }}
            let(:real_name) { :text1 }
            before {
              options[:as] = real_name
              ((subject.context[:filter_query] ||= {})[:fields] ||= {})[:text1] = original_option
            }
            it 'should delete the filter_query fields options for :as field' do
              expect(subject.context[:filter_query][:fields]).to receive(:delete).with(real_name)
              subject.field field_name, options
            end
            it 'should merge the original options into the new options' do
              subject.field field_name, options
              expect(subject.context[:filter_query][:fields][field_name]).to include({hello: 'world' })
            end
            it 'should not override the new options' do
              subject.field field_name, options
              expect(subject.context[:filter_query][:fields][field_name]).to include(override: false)
            end
          end
        end

        context 'when options :default is passed in' do
          let(:proc) { Proc.new { } }
          let(:options) {{ default: proc }}
          it 'should remove the default lambda or proc from the options' do
            expect(options).to receive(:delete).with(:default)
            subject.field field_name, options
          end
          it 'should create a literal node using Query::Domain::Literal' do
            domain = Query::Domain::Literal.new(field_name, {}, self)
            expect(Query::Domain::Literal).to receive(:new).with(field_name, {}, self).and_return(domain)
            expect(domain).to receive(:_eval) { |&block| expect(block).to eq proc }
            subject.field field_name, options
          end

          context 'when default proc/lambda returns value' do
            let(:proc) { Proc.new { "name" } }
            it 'should store the literal node in filter query defaults of context' do
              node = Query::Domain::Literal.new(field_name, {}, self)._eval(&proc)
              allow_any_instance_of(Query::Domain::Literal).to receive(:_eval).and_return(node)
              expect{ subject.field field_name, options }.to change{ subject.context[:filter_query] }.from(nil).to(hash_including(defaults: include(node)))
            end
          end

          context 'when default proc/lambda returns nothing' do
            it 'should not create any literal node in filter query defaults of context' do
              node = Query::Domain::Literal.new(field_name, {}, self)._eval(&proc)
              allow_any_instance_of(Query::Domain::Literal).to receive(:_eval).and_return(node)
              expect{ subject.field field_name, options }.to_not change{ subject.send(:filter_query_defaults) }.from([])
            end
          end
        end

        it 'should create an field accessor' do
          field_name = :an_indexed_field
          expect{ subject.field field_name, {} }.to change{ Query::DSL::FieldAccessors.instance_methods }.by([field_name])
        end

        context 'when options is passed in' do
          let(:options) {{ hello: "world" }}
          it 'should store the options in filter query fields' do
            subject.field field_name, options
            expect(subject.context[:filter_query][:fields][field_name]).to eq options
          end
        end

        context 'when no options is passed in' do
          it 'should create a options in filter query fields' do
            subject.field field_name
            expect(subject.context[:filter_query][:fields][field_name]).to eq({})
          end
        end
      end

      describe '#scope' do
        let(:scope_name) { :test_scope }
        context 'when no proc or block is given' do
          it 'should not add anything to filter query scopes' do
            expect{ subject.scope(scope_name) }.to_not change{ subject.send(:filter_query_scopes) }
          end
        end
        context 'when proc is given' do
          let(:proc) { Proc.new {} }
          it 'should add the proc to the filter query scopes' do
            expect{ subject.scope(scope_name, proc) }.to change{ subject.send(:filter_query_scopes) }.from({}).to(hash_including( scope_name => proc))
          end
        end
        context 'when block is given' do
          let(:block) { -> { "block" } }
          it 'should add the block to the filter query scopes' do
             expect{ subject.scope(scope_name, &block) }.to change{ subject.send(:filter_query_scopes) }.from({}).to(scope_name => eq(block))
          end
        end
      end

      context 'when method missing' do
        let(:undefined_method) { :undefined_method }
        let(:args) { [1,2,3] }
        context 'and builder resposnds to the method' do
          let(:builder) { subject.builder }
          before { allow(subject).to receive(:builder).and_return(builder) }
          it 'should check if builder responds to the method' do
            expect(builder).to receive(:respond_to?).with(undefined_method)
            subject.undefined_method rescue nil
          end
          it 'should call method on builder with parameters passed in' do
            allow(builder).to receive(:respond_to?).and_return(true)
            expect(builder).to receive(undefined_method).with(*args)
            subject.undefined_method(*args)
          end
        end

        context 'and builder not responds to the methods but searchable do' do
          it 'should check if callee existing and responds to the method' do
            expect(searchable).to receive(:respond_to?).with(undefined_method)
            subject.undefined_method rescue nil
          end
          it 'should call method on searchable with parameters passed in' do
            allow(searchable).to receive(:respond_to?).and_return(true)
            expect(searchable).to receive(undefined_method).with(*args)
            subject.undefined_method(*args)
          end
        end

        context 'both builder and searchable do not respond to the method' do
          it 'should raise NoMethodError on subject' do
            expect{ subject.undefined_method }.to raise_error(NoMethodError)
          end
        end

      end

    end
  end
end
