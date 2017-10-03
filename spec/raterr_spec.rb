require "spec_helper"

RSpec.describe Raterr do
  it 'has a version number' do
    expect(Raterr::VERSION).not_to be nil
  end

  describe 'AVAILABLE_PERIODS' do
    it 'has a list of available periods' do
      expect(described_class::AVAILABLE_PERIODS)
        .to eq [:minute, :hour, :day, :week, :month]
    end
  end

  describe 'DEFAULTS' do
    it 'has a list of defaut options' do
      expect(described_class::DEFAULTS[:code]).to eq 429
      expect(described_class::DEFAULTS[:max]).to eq 100
      expect(described_class::DEFAULTS[:period]).to eq :hour
    end
  end

  describe '.enforce' do

    let(:request) { Request.new }
    let(:options) { { period: :minute, max: 5 } }

    it 'call the period builder and returns a new period' do
      period = instance_double(Raterr::Minute, allowed?: true, proceed: { attempts: 1 })
      expect(Raterr::PeriodBuilder)
        .to receive(:call)
        .with(request, options) { period }

      described_class.enforce(request, options)
    end

    it 'creates a rate limit period and returns the next attempt count' do
      limit = described_class.enforce(request, options)

      expect(limit).to eq status: 200, attempts: 2
    end

    it 'creates a rate limit period and returns an exceeded status and message' do
      5.times { described_class.enforce(request, options) }

      expect(described_class.enforce(request, options))
        .to eq status: 429,
               text: 'Rate limit exceeded. Try again in 59 seconds.'
    end
  end
end
