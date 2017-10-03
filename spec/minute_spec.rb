require 'spec_helper'

RSpec.describe Raterr::Minute do

  let(:request) do
      Class.new do
        def ip
          'some_ip'
        end
      end.new
    end
  let(:options) { { period: :minute, max: 5 } }
  subject { described_class.new(request, options) }

  describe '#initialize' do
    it 'initializes the period' do
      expect(subject.request).to eq(request)
      expect(subject.options).to eq(options)
    end
  end

  describe '#rate_limit_exceeded' do
    it 'returns a limit exceeded status and message' do
      expect(subject.rate_limit_exceeded)
        .to eq status: 429, text: 'Rate limit exceeded. Try again in 60 seconds.'
    end
  end

  describe '#allowed?' do
    it 'returns true - the rate limit has not been exceeded' do
      expect(subject.allowed?).to eq true
    end

    it 'returns false - the rate limit has been exceeded' do
      5.times { subject.proceed }
      expect(subject.allowed?).to eq false
    end
  end

  describe '#proceed' do
    it 'proceeds with the request attempts' do
      expect(subject.proceed).to eq attempts: 2
    end
  end
end
