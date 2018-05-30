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
    
    ipsetsGroupedByRule = {}
    
    ipsets.each do |ipset_name, ipset_value| 

        # remove "ipsets." magic words from keys
        nameReplaced = ipset_name.gsub("ipsets.", "")
               
        ipset_value.each do |ip, details|  

            # construct the ipset name (e.g savagaming_accept or savagaming_drop)
            ipset_name = nameReplaced + "_" + details["Rule"]

            unless ipsetsGroupedByRule[ipset_name]
                ipsetsGroupedByRule[ipset_name] = []
            end

            ipsetsGroupedByRule[ipset_name] << ip

        end

    end

    ipsetsGroupedByRule

end

ipsets = get_consul_ipsets("http://localhost:8500/v1/kv/config/bundle/ipsets")

Facter.add('consul_ipsets') do
  setcode do
    ipsets
  end
end