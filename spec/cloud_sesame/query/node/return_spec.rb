require "spec_helper"

module CloudSesame
  module Query
    module Node
      describe Return do
        describe 'compile' do
          it 'compiles to a string when there are fields' do
            r = Return.new({})
            r.fields = ['_score','identifiers']
            expect(r.compile).to eq('_score,identifiers')
          end
          it 'returns nil if there are no fields' do
            r = Return.new({})
            expect(r.compile).to be_nil
          end
        end
      end
    end
  end
end

