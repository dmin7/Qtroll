class 'OscServer'
  function OscServer:__init(port, callback)
    self.hostname = "localhost"
    self.port = port
    self.server = nil
    self.socket_error = nil
    self.running = false
    self:start()
  end

  function OscServer:start()
    if self.running then
      self:stop()
    end
    self.server, self.socket_error = renoise.Socket.create_server(
        self.hostname, self.port, renoise.Socket.PROTOCOL_UDP)
    
    if (self.socket_error) then 
      renoise.app():show_warning(("Failed to start the " .. 
          "OSC server. Error: '%s'"):format(socket_error))
      self.running = false
    else
      self.running = true
    end
    
    self.server:run {
      socket_message = function(socket, data)
        -- decode the data to Osc
        local message_or_bundle, osc_error = renoise.Osc.from_binary_data(data)
        
        -- show what we've got
        if (message_or_bundle) then
          if (type(message_or_bundle) == "Message") then
            print(("Got OSC message: '%s'"):format(tostring(message_or_bundle)))
    
          elseif (type(message_or_bundle) == "Bundle") then
            print(("Got OSC bundle: '%s'"):format(tostring(message_or_bundle)))
          
          else
            -- never will get in here
          end
          callback(message_or_bundle)
          
        else
          print(("Got invalid OSC data, or data which is not " .. 
            "OSC data at all. Error: '%s'"):format(osc_error))
        end
      end
    }
    
  end
  
  function OscServer:stop()
    self.server:close()
  end

