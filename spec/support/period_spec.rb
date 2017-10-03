RSpec.shared_examples :period do |time_period|

  let(:request) { Request.new }
  let(:options) { { period: :minute, max: 5 } }
  let(:time_period) { time_period }
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
        .to eq status: 429, text: "Rate limit exceeded. Try again in #{after_period}."
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

  private

  def after_period
    if time_period == :minute
      '60 seconds'
    elsif time_period == :hour
      '60 minutes'
    elsif time_period == :day
      '24 hours'
    end
  end
end
