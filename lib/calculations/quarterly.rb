# frozen_string_literal: true

module Calculations
  module Quarterly
    QUARTER_MONTHS_COUNT_WITHOUT_START_MONTH = 2
    QUARTER_MONTH_NUMBERS = [3, 6, 9, 12].freeze

    def date_range(date)
      end_of_quartal = end_period(date)

      [start_period(end_of_quartal), end_of_quartal]
    end

    private

    def start_period(date)
      DateTime.new(date.year, date.month - QUARTER_MONTHS_COUNT_WITHOUT_START_MONTH, 1)
    end

    def end_period(date)
      end_month = QUARTER_MONTH_NUMBERS.detect { |month| month >= date.month }

      end_date = DateTime.new(date.year, end_month, 1)
      end_date.next_month - end_date.next_month.mday
    end
  end
end
