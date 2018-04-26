module Puppet::Parser::Functions
    newfunction(:get_consul_ipsets) do |args|
      
        require 'net/http'
        require 'json'
        require "base64"
        
        def get_consul_values_as_hash (url)
        
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
            
            # return parsed version of the config as a hash
            JSON.parse(responseBodyDecoded)
        end
        
        def remove_magic_strings(foo)
            
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
        
        url = args[0]
            
        # get ipsets from consul
        ipsets = get_consul_values_as_hash(url)
        
        # remove magic strings needed, so ipsets fit in Conan
        remove_magic_strings(ipsets)
        
    end
 end