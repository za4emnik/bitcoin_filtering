# frozen_string_literal: true

module Calculations
  DAYS = 1

  module Daily
    def date_range(date)
      [date, date]
    end

    def days_in_period(_)
      DAYS
    end
  end
end
