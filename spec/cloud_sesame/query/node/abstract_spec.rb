require 'spec_helper'

module CloudSesame
  module Query
    module Node
      describe Abstract do
        let(:context) { :context }
        subject { Abstract.new(context) }

        describe '#initialize' do
          it 'should store context' do
            expect(subject.context).to eq context
          end
        end

      end
    end
  end
end
