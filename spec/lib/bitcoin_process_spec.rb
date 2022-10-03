# frozen_string_literal: true

require 'spec_helper'
require './lib/bitcoin_process'

RSpec.describe BitcoinProcess do
  subject(:service) do
    described_class.new(
      order_dir: order_dir,
      filter_date_from: filter_date_from,
      filter_date_to: filter_date_to,
      granularity: granularity
    )
  end

  describe '#call' do
    let(:order_dir) { :desc }
    let(:filter_date_from) { nil }
    let(:filter_date_to) { nil }
    let(:granularity) { nil }
    let(:data) { service.instance_variable_get(:@data) }

    before { VCR.insert_cassette('bitcoin_data') }
    after { VCR.eject_cassette('bitcoin_data') }

    context 'with order' do
      let(:expected_result) { data.map { |item| item['date'] }.sort_by { |item| DateTime.parse(item) } }

      context 'when sorted in descending order' do
        it 'retruns descending array' do
          expect(service.call.map(&:first)).to eq(expected_result.reverse)
        end
      end

      context 'when sorted in ascending order' do
        let(:order_dir) { :asc }

        it 'retruns ascending array' do
          expect(service.call.map(&:first)).to eq(expected_result)
        end
      end
    end

    context 'with filter_date_from' do
      let(:expected_result) do
        data.reject { |item| DateTime.parse(item['date']) < DateTime.parse(filter_date_from.to_s) }
            .map { |item| item['date'] }.reverse
      end

      context 'when filter passed as string' do
        let(:filter_date_from) { '2018-11-11' }

        it 'returns filtered array by start date' do
          expect(service.call.map(&:first)).to eq(expected_result)
        end
      end

      context 'when filter passed as time object' do
        let(:filter_date_from) { Time.new('2018', '11', '11') }

        it 'returns filtered array by start date' do
          expect(service.call.map(&:first)).to eq(expected_result)
        end
      end
    end

    context 'with filter_date_to' do
      let(:expected_result) do
        data.reject { |item| DateTime.parse(item['date']) > DateTime.parse(filter_date_to.to_s) }
            .map { |item| item['date'] }.reverse
      end

      context 'when filter passed as string' do
        let(:filter_date_to) { '2018-11-11' }

        it 'returns filtered array by end date' do
          expect(service.call.map(&:first)).to eq(expected_result)
        end
      end

      context 'when filter passed as date object' do
        let(:filter_date_to) { Date.new(2018, 11, 11) }

        it 'returns filtered array by end date' do
          expect(service.call.map(&:first)).to eq(expected_result)
        end
      end
    end

    context 'with granuarity' do
      let(:coins) { (1..5).map { |_number| rand(100.0..1000.0) } }

      before { VCR.insert_cassette('bitcoin_data_by_period', erb: { dates: dates, coins: coins }) }
      after { VCR.eject_cassette('bitcoin_data_by_period') }

      context 'when passed unknown granularity' do
        let(:granularity) { :unknown_granularity }
        let(:dates) { (1..5).map { |number| "2011-01-0#{number}" }.reverse }

        it 'returns daily granularity data' do
          expect(service.call).to eq([dates, coins].transpose)
        end
      end

      context 'when passed weelky granularity' do
        let(:granularity) { :weekly }
        let(:dates) { (1..5).map { "2011-03-#{rand(21..27)}" } }
        let(:start_day) { '2011-03-21' }

        it 'returns weekly granularity data' do
          expect(service.call).to eq([[start_day, coins.sum / Calculations::Weekly::WEEK_DAYS_COUNT]])
        end
      end

      context 'when passed monthly granularity' do
        let(:granularity) { :monthly }
        let(:dates) { (1..5).map { "2011-01-#{rand(10..31)}" } }
        let(:start_day) { '2011-01-01' }
        let(:days_in_current_month) { 31 }

        it 'returns monthly granularity data' do
          expect(service.call).to eq([[start_day, coins.sum / days_in_current_month]])
        end
      end

      context 'when passed quarterly granularity' do
        let(:granularity) { :quarterly }
        let(:dates) { (1..5).map { "2011-#{rand(10..12)}-#{rand(10..28)}" } }
        let(:start_day) { '2011-10-01' }
        let(:days_in_current_month) { 92 }

        it 'returns quarterly granularity data' do
          expect(service.call).to eq([[start_day, coins.sum / days_in_current_month]])
        end
      end
    end
  end
end
