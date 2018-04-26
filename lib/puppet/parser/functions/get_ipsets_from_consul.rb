module Puppet::Parser::Functions
    newfunction(:get_ipsets_from_consul, :type => :rvalue) do |args|
      
        require 'net/http'
        require 'json'
        require "base64"
        
        # get url from args
        url = args[0]
        
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
        
        fooReplaced = {}
            
        foo.each do |k, v| 
            # remove "ipsets." magic words from keys
            kReplaced = k.gsub("ipsets.", "")
            
            # replace commas with newlines in the values
            vReplaced = v.gsub(", ", "\n")
            
            fooReplaced[kReplaced] = vReplaced
        end
    
        fooReplaced

    end
 end