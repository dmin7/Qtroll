
local dialog = nil
local vb = nil

function show_config()

  if dialog and dialog.visible then
    dialog:show()
    return
  end

  vb = renoise.ViewBuilder()

  local DEFAULT_DIALOG_MARGIN = 
    renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
  local DEFAULT_CONTROL_SPACING = 
    renoise.ViewBuilder.DEFAULT_CONTROL_SPACING
  local DEFAULT_BUTTON_HEIGHT =
    renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT 
  local DIALOG_WIDTH = 240

  local dialog_title = "Qtroll: Configuration"
  local dialog_buttons = {"Close"};

  
  -- dialog content 
  
  local dialog_content = vb:column {
    margin = DEFAULT_DIALOG_MARGIN,
    spacing = DEFAULT_CONTROL_SPACING,
    width = DIALOG_WIDTH,
    uniform = true,
    
    
     vb:horizontal_aligner { 
        mode = "justify",
        vb:text { text = "Osc HOSTNAME: " },
        vb:textfield {
            bind = prefs.hostname,
            notifier = configUpdated
          },
     },
     
     vb:horizontal_aligner { 
        mode = "justify",
        vb:text { text = "PORT client control: " },
        vb:valuebox {
            min = 0,
            max = 100000,
            bind = prefs.client_port_ctrl,
            notifier = configUpdated
          },
     },
     
     vb:horizontal_aligner { 
        mode = "justify",
        vb:text { text = "PORT client notes: " },
        vb:valuebox {
            min = 0,
            max = 100000,
            bind = prefs.client_port_notes,
            notifier = configUpdated
          },
     },
     
     vb:horizontal_aligner { 
        mode = "justify",
        vb:text { text = "PORT server notes: " },
        vb:valuebox {
            min = 0,
            max = 100000,
            bind = prefs.server_port_notes,
            notifier = configUpdated
          },
     },
     
     
     vb:horizontal_aligner {
        mode = "justify",
        vb:text{ text = "Start with renoise: "},
        vb:checkbox {
          bind = prefs.autostart,
          notifier = configUpdated
        },
     
     },
         
  }
  
    -- show
  
  dialog = renoise.app():show_custom_dialog(
    dialog_title, dialog_content, function(key) return key end)
end



