require 'puppet'
require 'net/http'
require 'json'
require "base64"

def get_consul_ipsets(url)
        
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    
    responseBodyParsed = ""
    if response.code === "200"
        responseBodyParsed = JSON.parse(response.body)    
    else
        raise response.message
    end
    
    # responses from consul API come as base64 encoded
    responseBodyDecoded = Base64.decode64(responseBodyParsed.first["Value"])
    
    # get parsed version of the config as a hash
    ipsets = JSON.parse(responseBodyDecoded)
    
    ipsetsReplaced = {}
        
    ipsets.each do |k, v| 
        # remove "ipsets." magic words from keys
        kReplaced = k.gsub("ipsets.", "")
        
        # replace commas with newlines in the values
        vReplaced = v.gsub(", ", "\n")
        
        ipsetsReplaced[kReplaced] = vReplaced
    end

    ipsetsReplaced

end

ipsets = get_consul_ipsets("http://localhost:8500/v1/kv/config/bundle/ipsets")

Facter.add('consul_ipsets') do
  setcode do
    ipsets
  end
end