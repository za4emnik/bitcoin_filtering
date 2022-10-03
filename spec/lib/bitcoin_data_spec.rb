# frozen_string_literal: true

require 'spec_helper'
require './lib/bitcoin_data'

RSpec.describe BitcoinData do
  describe '#call' do
    let(:call) { described_class.call }

    before { VCR.insert_cassette('bitcoin_data') }
    after { VCR.eject_cassette('bitcoin_data') }

    it 'call data endpoint' do
      allow(Net::HTTP).to receive(:get_response).and_call_original

      expect(call).to be_a(Array)

      expect(Net::HTTP).to have_received(:get_response).with(URI.parse(described_class::DATA_URI))
    end
  end
end
