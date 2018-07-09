module Puppet::Parser::Functions
    newfunction(:get_ipsets_from_consul, :type => :rvalue) do |args|
       
        require 'net/http'
        require 'json'
        require "base64"
        
        # get config from args
        url = args[0]
        defaultbundle = args[1]
        rolebundle = args[2]

        # Get ipsets from default bundle
        # ------------------------------
        uri = URI.parse(url + defaultbundle)
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

        # ------------------------------

        # Get ipsets from role-specific bundle
        # ------------------------------
        uri = URI.parse(url + rolebundle)
        response = Net::HTTP.get_response(uri)
        
        if response.code === "200"
            
            responseBodyParsed = JSON.parse(response.body)  
            
            # responses from consul API come as base64 encoded
            responseBodyDecoded = Base64.decode64(responseBodyParsed.first["Value"])
            
            # get parsed version of the config as a hash
            roleipsets = JSON.parse(responseBodyDecoded)  
            
            # add the role-specific ipsets config to the default one
            ipsets = ipsets.merge(roleipsets)

        elsif response.code === "404"
            # drop a message to the logs if no role-specific bundle has been found
            # that's non-breaking and expected for most roles
            debug("No role-specific bundle with ipsets for role #{rolebundle} in Consul. This might be expected.")
        else
            raise response.message
        end
        
        # ------------------------------


        ipsetsGroupedByRuleAndPriority = {}
        
        ipsets.each do |ipset_name, ipset_value| 

            # remove "ipsets." magic words from keys
            nameReplaced = ipset_name.gsub("ipsets.", "")
                
            ipset_value.each do |ip, details|  

                # construct the ipset name (e.g savagaming|accept|888 or savagaming|drop|045)
                ipset_name = nameReplaced + "|" + details["Rule"] + "|" + details["Priority"]

                unless ipsetsGroupedByRuleAndPriority[ipset_name]
                    ipsetsGroupedByRuleAndPriority[ipset_name] = []
                end

                ipsetsGroupedByRuleAndPriority[ipset_name] << ip

            end

        end

        ipsetsGroupedByRuleAndPriority
    end
end



    