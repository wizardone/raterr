require 'spec_helper'

RSpec.describe Raterr::Day do

  let(:request) { Request.new }
  let(:options) { { period: :day, max: 5 } }
  subject { described_class.new(request, options) }

  it_behaves_like :period, Request.new, { period: :day, max: 5 }

  describe '#rate_limit_exceeded' do
    it 'returns a limit exceeded status and message' do
      repeat_period = Raterr.store == Hash.new ? REPEAT_PERIODS[:day][:hash] :
                                                 REPEAT_PERIODS[:day][:redis]
      expect(subject.rate_limit_exceeded)
        .to eq status: 429, text: "Rate limit exceeded. Try again in #{repeat_period} hours."
    end
  end
end
