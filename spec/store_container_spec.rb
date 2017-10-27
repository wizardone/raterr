require 'spec_helper'

RSpec.describe Raterr::StoreContainer do

  let(:store) { Hash.new }
  let(:identifier) { 'some_ip' }

  describe '#initialize' do
    it 'initializes the store container' do
      store_container = described_class.new(store: store, identifier: identifier)

      expect(store_container.store).to eq(store)
      expect(store_container.identifier).to eq(identifier)
    end
  end

  describe '#resolve' do

    let(:store_default) { { 'attempts' => 1, 'start_time' => Time.now } }

    context 'hash storage' do

      let(:subject) { described_class.new(store: store, identifier: identifier) }

      it 'resolves the get method' do
        expect(store).to receive(:fetch).with(identifier) { store_default }

        subject.resolve(:get)
      end

      it 'resolves the set method' do
        attrs = { attempts: 5 }
        expect(store).to receive(:[]=).with(identifier, attrs)

        subject.resolve(:set, attrs)
      end

      it 'resolves the delete method' do
        expect(store).to receive(:delete).with(identifier)

        subject.resolve(:delete, identifier)
      end
    end

    context 'redis storage' do

      let(:store) { Redis.new }
      let(:subject) { described_class.new(store: store, identifier: identifier) }

      it 'resolves the get method' do
        expect(store).to receive(:get).with(identifier) { store_default.to_json }

        subject.resolve(:get)
      end

      it 'resolves the set method' do
        attrs = { attempts: 5 }
        expect(store).to receive(:set).with(identifier, attrs.to_json)

        subject.resolve(:set, attrs)
      end

      it 'resolves the delete method' do
        expect(store).to receive(:del).with(identifier)

        subject.resolve(:delete, identifier)
      end
    end
  end

  describe '#resolvers' do

  end
end
