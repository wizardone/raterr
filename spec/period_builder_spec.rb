require 'spec_helper'

RSpec.describe Raterr::PeriodBuilder do

  let(:request) do
      Class.new do
        def ip
          'some_ip'
        end
      end.new
    end
  let(:options) { { period: :minute, max: 5 } }

  describe '.call' do
    it 'call the process of generating a period' do
      builder = instance_double(described_class, build: true)
      expect(described_class)
        .to receive(:new)
        .with(request, options) { builder }

      described_class.call(request, options)
    end
  end

  describe '#initialize' do
    it 'initializes the period builder' do
      period_builder = described_class.new(request, options)

      expect(period_builder.period).to eq(options[:period])
      expect(period_builder.request).to eq(request)
      expect(period_builder.options).to eq(options)
    end
  end

  describe '#build' do
    it 'builds the proper rate limit class for a minute' do
      expect(Raterr::Minute).to receive(:new).with(request, options)

      period_builder = described_class.new(request, options).build
    end

    it 'builds the proper rate limit class for a hour' do
      expect(Raterr::Hour).to receive(:new).with(request, options.merge(period: :hour))

      period_builder = described_class.new(request, options.merge(period: :hour)).build
    end

    it 'builds the proper rate limit class for a day' do
      expect(Raterr::Day).to receive(:new).with(request, options.merge(period: :day))

      period_builder = described_class.new(request, options.merge(period: :day)).build
    end
  end
end
