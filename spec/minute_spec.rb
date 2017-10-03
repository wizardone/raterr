require 'spec_helper'

RSpec.describe Raterr::Minute do

  let(:request) { Request.new }
  let(:options) { { period: :minute, max: 5 } }
  subject { described_class.new(request, options) }

  it_behaves_like :period, Request.new, { period: :minute, max: 5 }

  describe '#rate_limit_exceeded' do
    it 'returns a limit exceeded status and message' do
      expect(subject.rate_limit_exceeded)
        .to eq status: 429, text: 'Rate limit exceeded. Try again in 60 seconds.'
    end
  end
end
