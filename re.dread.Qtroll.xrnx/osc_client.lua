class 'OscClient'
  function OscClient:__init(hostname, port)
    self.hostname = hostname
    self.port = port
    self.client = nil
    self.socket_error = nil
    self.connected = false
    self:connect()
  end

  function OscClient:connect()
    if self.connected then
    
    end
    self.client, self.socket_error = renoise.Socket.create_client(
        self.hostname, self.port, renoise.Socket.PROTOCOL_UDP)
    
    if (self.socket_error) then 
      renoise.app():show_warning(("Failed to start the " .. 
          "OSC client. Error: '%s'"):format(socket_error))
    end
  end
  
  function OscClient:send(msg)
    --print("sending OSC message: " .. msg)
    self.client:send(msg)
  end

