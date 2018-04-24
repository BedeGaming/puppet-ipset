module Puppet::Parser::Functions
    newfunction(:get_json_data) do |args|
      url = args[0]
      $response = Net::HTTP.get_response(URI.parse(url))
      JSON.parse($response)
    end
  end