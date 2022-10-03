# frozen_string_literal: true

module Calculations
  module Weekly
    WEEK_DAYS_COUNT = 7
    WEEK_DAYS_STARTS_FROM_ZERO = 6

    def date_range(date)
      beggining_of_week = start_period(date)

      [beggining_of_week, end_period(beggining_of_week)]
    end

    def days_in_period(_)
      WEEK_DAYS_COUNT
    end

    private

    def start_period(date)
      date - wdays_beggining_from_monday(date)
    end

    def end_period(beggining_of_week)
      beggining_of_week + WEEK_DAYS_STARTS_FROM_ZERO
    end

    def wdays_beggining_from_monday(date)
      (date.wday + WEEK_DAYS_STARTS_FROM_ZERO) % WEEK_DAYS_COUNT
    end
  end
end
