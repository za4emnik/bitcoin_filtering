# frozen_string_literal: true

require 'bundler/setup'

Bundler.require(:default, :test)

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end
