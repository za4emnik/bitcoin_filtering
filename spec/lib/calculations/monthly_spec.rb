# frozen_string_literal: true

require 'spec_helper'
require './lib/calculations/monthly'

RSpec.describe Calculations::Monthly do
  subject(:calculation) { Class.new }

  before { calculation.singleton_class.include(described_class) }

  describe '#data_range' do
    subject(:date_range) { calculation.date_range(date) }

    let(:date) { DateTime.new(2011, 1, rand(1..31)) }
    let(:start_day) { DateTime.new(2011, 1, 1) }
    let(:end_day) { DateTime.new(2011, 1, 31) }

    it 'returns monthly date range' do
      expect(date_range).to eq([start_day, end_day])
    end
  end
end
