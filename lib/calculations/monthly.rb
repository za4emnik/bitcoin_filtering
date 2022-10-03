# frozen_string_literal: true

module Calculations
  module Monthly
    DAYS = 1

    def date_range(date)
      [start_period(date), end_period(date)]
    end

    private

    def start_period(date)
      date - date.mday + 1
    end

    def end_period(date)
      date.next_month - date.next_month.mday
    end
  end
end
