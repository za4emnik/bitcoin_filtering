# frozen_string_literal: true

require './lib/bitcoin_data'
require './lib/calculations/monthly'
require './lib/calculations/quarterly'
require './lib/calculations/weekly'
require './lib/calculations/daily'

class BitcoinProcess
  CALCULATION_MODULES = {
    daily: Calculations::Daily,
    weekly: Calculations::Weekly,
    monthly: Calculations::Monthly,
    quarterly: Calculations::Quarterly
  }.freeze

  DATE_FORMAT = '%Y-%m-%d'

  def initialize(order_dir: :desc, filter_date_from: nil, filter_date_to: nil, granularity: nil)
    @order_dir = order_dir
    @filter_date_from = filter_date_from ? DateTime.parse(filter_date_from.to_s) : nil
    @filter_date_to = filter_date_to ? DateTime.parse(filter_date_to.to_s) : nil
    @data = ::BitcoinData.call

    singleton_class.include(CALCULATION_MODULES[granularity] || CALCULATION_MODULES[:daily])
  end

  def call
    slice
    filter
    groupping
    sum_coins
    order
    prepare_response
  end

  private

  attr_reader :data, :order_dir, :filter_date_from, :filter_date_to, :result

  def slice
    @result = data.map do |item|
      {
        date: DateTime.parse(item['date']),
        price: item['price(USD)']
      }
    end
  end

  def filter
    return if !filter_date_from && !filter_date_to

    @result = result.reject do |item|
      (filter_date_from && item[:date] < filter_date_from) ||
        (filter_date_to && item[:date] > filter_date_to)
    end
  end

  def groupping
    @result = result.group_by do |item|
      range = date_range(item[:date])

      range.first if item[:date].between?(*range)
    end
  end

  def sum_coins
    @result = result.each_with_object({}) do |(key, value), hash|
      hash[key] = value.sum { |item| item[:price].to_f } / days_in_period(key)
    end
  end

  def days_in_period(date)
    date_range(date).reverse.reduce(:-).to_i + 1
  end

  def order
    @result = result.sort_by(&:first)

    @result = result.reverse if order_dir == :desc
  end

  def prepare_response
    result.map { |item| [item.shift.strftime(DATE_FORMAT), *item] }
  end
end
