require "spec_helper"

module CloudSesame
  module Query
    module Node
      describe Query do
        let(:context) {{ }}
        let(:node) { Query.new(context) }
        subject { Query.new(context) }

        describe '#query' do
          context 'when context include query on initialize' do
            let(:query_string) { "hello world" }
            let(:context) { { query: query_string }}
            it 'should set query to context query' do
              expect(subject.query).to eq query_string
            end
          end
          context 'when context does not include query on initialize' do
            it 'should just return nil' do
              expect(subject.query).to eq nil
            end
          end
        end

        describe '#compile' do

          shared_examples 'common query compile actions' do
            context 'and query is nil' do
              let(:query_string) { nil }
              it 'should return nil' do
                expect(subject.compile).to eq nil
              end
            end
            context 'and query is empty' do
              let(:query_string) { "" }
              it 'should return nil' do
                expect(subject.compile).to eq nil
              end
            end
            context 'and query contains one word' do
              let(:query_string) { "oneword" }
              it 'should include the original string inside parenthesis' do
                expect(subject.compile[:query]).to include("(#{ query_string })")
              end
            end
            context 'and query contains multiple words' do
              let(:query_string) { "one three fourty longword" }
              it 'should include the original string inside parenthesis' do
                expect(subject.compile[:query]).to include("(#{ query_string })")
              end
            end
          end

          shared_examples 'with additional parser defined' do |parser_name|
            context 'and query string is nil' do
              let(:query_string) { nil }
              it "should not trigger #{ parser_name }" do
                expect(parser).to_not receive(:compile)
                subject.compile
              end
            end
            context 'and query string is empty' do
              let(:query_string) { "" }
              it "should not trigger #{ parser_name }" do
                expect(parser).to_not receive(:compile)
                subject.compile
              end
            end
            context 'and query string exist and not empty' do
              let(:query_string) { "not empty" }
              it "should trigger #{ parser_name }" do
                result = parser.compile(query_string)
                expect(parser).to receive(:compile).with(query_string).and_call_original
                expect(subject.compile[:query]).to include(result)
              end
            end
          end

          context 'when both fuzziness and sloppiness are not defined' do
            let(:context) {{ query: query_string }}
            include_examples 'common query compile actions'
          end
          context 'when fuzziness is defined' do
            let(:parser) { Fuzziness.new }
            let(:context) {{
              query: query_string,
              fuzziness: parser
            }}
            include_examples 'common query compile actions'
            include_examples 'with additional parser defined', "fuzziness"
          end
          context 'when sloppiness is defined' do
            let(:parser) { Sloppiness.new(3) }
            let(:context) {{
              query: query_string,
              sloppiness: parser
            }}
            include_examples 'common query compile actions'
            include_examples 'with additional parser defined', "sloppiness"
          end
        end

      end
    end
  end
end

