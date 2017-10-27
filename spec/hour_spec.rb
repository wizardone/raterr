require 'spec_helper'

RSpec.describe Raterr::Hour do

  let(:request) { Request.new }
  let(:options) { { period: :hour, max: 5 } }
  subject { described_class.new(request, options) }

  it_behaves_like :period, Request.new, { period: :hour, max: 5 }

  describe '#rate_limit_exceeded' do
    it 'returns a limit exceeded status and message' do
      repeat_period = Raterr.store == Hash.new ? REPEAT_PERIODS[:hour][:hash] :
                                                 REPEAT_PERIODS[:hour][:redis]
      expect(subject.rate_limit_exceeded)
        .to eq status: 429, text: "Rate limit exceeded. Try again in #{repeat_period} minutes."
    end
  end
end
