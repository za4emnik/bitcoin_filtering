# README

- `order_dir`: Order by date: `desc`, `asc` (`desc` by default).
- `filter_date_from`: string or date object. List will filter by this date as a start date.
- `filter_date_to`: string or date object. List will filter by this date as an end date.
- `granularity`: `daily` (by default), `weekly`, `monthly` and `quarterly`. This parameter will group price data by the given period. Based on granularity, date will the first day of week, month, etc. Price in each group will calculated as `average` value. F.e: granularity is `weekly`, price = `price_sum_for_week / 7`.

# USING

> irb

> require './lib/bitcoin_process.rb'

> process = BitcoinProcess.new(order_dir: :desc, filter_date_from: '2018-11-11', filter_date_to: '2018-12-12', granularity: :weekly)

> process.call

> [["2018-11-19", 2794.5457142857144], ["2018-11-12", 5950.854285714285], ["2018-11-05", 916.2328571428571]]
