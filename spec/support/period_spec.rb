RSpec.shared_examples :period do |request, options|

  let(:request) { request }
  let(:options) { options }
  subject { described_class.new(request, options) }

  describe '#initialize' do
    it 'initializes the period' do
      expect(subject.request).to eq(request)
      expect(subject.options).to eq(options)
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
      expect(subject.proceed).to eq status: 200, attempts: 2
    end
  end
end
