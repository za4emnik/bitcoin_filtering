# frozen_string_literal: true

require 'spec_helper'
require './lib/calculations/weekly'

RSpec.describe Calculations::Weekly do
  subject(:calculation) { Class.new }

  before { calculation.singleton_class.include(described_class) }

  describe '#data_range' do
    subject(:date_range) { calculation.date_range(date) }

    let(:date) { DateTime.new(2011, 3, rand(21..27)) }
    let(:start_day) { DateTime.new(2011, 3, 21) }
    let(:end_day) { DateTime.new(2011, 3, 27) }

    it 'returns weekly date range' do
      expect(date_range).to eq([start_day, end_day])
    end
  end

  describe '#days_in_period' do
    subject(:days_in_period) { calculation.days_in_period(date) }

    let(:date) { DateTime.now }

    it 'returns 7 days in period' do
      expect(days_in_period).to eq(7)
    end
  end
end
