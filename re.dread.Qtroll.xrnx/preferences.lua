-- preferences
function init_prefs()
  local prefs = renoise.Document.create("ScriptingToolPreferences") {
    
    -- default values
    hostname            = "192.168.3.24",
    client_port_ctrl    = 8004,
    client_port_notes   = 8005,
    server_port_notes   = 8006,
    autostart           = true
  }
  
  -- assign
  renoise.tool().preferences = prefs
  prefs:save_as("preferences.xml") 
end

-- do it
init_prefs()
