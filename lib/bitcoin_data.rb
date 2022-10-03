# frozen_string_literal: true

require 'json'
require 'net/http'

class BitcoinData
  DATA_URI = 'https://pkgstore.datahub.io/cryptocurrency/bitcoin/bitcoin_json/data/3d47ebaea5707774cb076c9cd2e0ce8c/bitcoin_json.json'

  def self.call
    JSON.parse(parsed_uri.body)
  end

  def self.parsed_uri
    Net::HTTP.get_response(URI.parse(DATA_URI))
  end
end
