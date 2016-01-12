require 'spec_helper'

module CloudSearch
  module Query
    module Node
      describe Request do
        let(:context) { Domain::Context.new }
        let(:request) { Request.new(context) }

        describe '#compile' do
          context 'when request is empty' do
            it 'should return an default request' do
              expect(request.compile).to include(
                query: "",
                query_parser: "structured",
                start: 0,
                size: 10
              )
              expect(request.compile).to_not include(:query_options, :filter_query, :sort)
            end
            it 'should set query_parser to structured' do
              expect(request.compile).to include(query_parser: 'structured')
            end
          end
          context 'when theres query' do
            before { request.query.query = "hello world" }
            it 'should includ query string' do
              expect(request.compile).to include(query: "hello world")
            end
            it 'should default query_parser to simple' do
              expect(request.compile).to include(query_parser: 'simple')
            end
          end
          context 'when theres query_options' do
            it 'should include query_options' do
              request.query_options.fields.concat [QueryOptionsField.new(:price)]
              expect(request.compile).to include(:query_options)
            end
          end
          context 'when theres filter query' do
            before { request.filter_query.root.and{ literal(:tags, "sale") } }
            let(:compiled) { request.filter_query.compile }
            context 'with query' do
              before { request.query.query = "hello" }
              it 'should include filter query' do
                expect(request.compile).to include(:filter_query)
              end
            end
            context 'without query' do
              before { request.query.query = "" }
              it 'should include query instead' do
                expect(request.compile).to include(:query)
              end
            end
          end
          context 'when theres page' do
            it 'should include start and size' do
              expect(request.compile).to include(:start, :size)
            end
          end
          context 'when theres sort' do
            before { request.sort[:price]= :asc }
            it 'should include sort' do
              expect(request.compile).to include(:sort)
            end
          end
        end
      end
    end
  end
end
