# frozen_string_literal: true

require 'spec_helper'
require './lib/calculations/daily'

RSpec.describe Calculations::Daily do
  subject(:calculation) { Class.new }

  let(:date) { DateTime.now }

  before { calculation.singleton_class.include(described_class) }

  describe '#data_range' do
    subject(:date_range) { calculation.date_range(date) }

    it 'returns daily date range' do
      expect(date_range).to eq([date, date])
    end
  end

  describe '#days_in_period' do
    subject(:days_in_period) { calculation.days_in_period(date) }

    it 'returns one day in period' do
      expect(days_in_period).to eq(1)
    end
  end
end
