--[[============================================================================
main.lua
============================================================================]]--

--[[@TODO:
  - line notifiers
  - recieve function
]]

-- preferences
require 'preferences'
prefs = renoise.tool().preferences

require 'gui'
require 'osc_client'
require 'osc_server'

documentation = nil

local OscMessage = renoise.Osc.Message
local OscBundle = renoise.Osc.Bundle

local osc_client_ctrl, osc_client_notes, osc_server_notes = nil
local is_running = false

function start()
  -- start OSC clients / server
  osc_client_ctrl   = OscClient(prefs.hostname.value, prefs.client_port_ctrl.value)
  osc_server_notes  = OscServer(prefs.server_port_notes.value, writeNoteData)
  -- update stuff
  is_running = true
  toggleMenu()
  registerNotifiers()
  -- remove autostart notifier
  if renoise.tool().app_new_document_observable:has_notifier(start) then
    renoise.tool().app_new_document_observable:remove_notifier(start)
  end
end

function stop()
  -- stop OSC clients / server
  osc_server_notes:stop()
  -- update stuff
  is_running = false
  toggleMenu()
  unregisterNotifiers()
end

function configUpdated()
  print("Qtroll: configuration updated: restarting .. ")
  if is_running then
    stop()
    start()
  end
end

events = {}
function sendNoteData()
  local track = renoise.song().selected_track
  -- make sure we're dealing with a track that actually has notes
  if (track.type == renoise.Track.TRACK_TYPE_MASTER or
      track.type == renoise.Track.TRACK_TYPE_SEND) then
      return
  end
  
  -- clear events
  events = {}
  print("notifier called")

  --@TODO: replace with /qtroll/new_pattern(length, lpb)!
  -- clear pattern
  osc_client_ctrl:send(
      OscMessage("/qtroll/clear"))

  -- send pattern length and lpb to qtroll
  local pattern_length = renoise.song().selected_pattern.number_of_lines
  osc_client_ctrl:send(
      OscMessage("/qtroll/pattern_length", { 
        {tag="i", value=pattern_length} 
      }))
  local lpb = renoise.song().transport.lpb
    osc_client_ctrl:send(
      OscMessage("/qtroll/lpb", { 
        {tag="i", value=lpb} 
      }))
      
  -- read events
  readEvents()
  
  -- send 'em
  for _, event in ipairs(events) do
    print("sending note")
    -- need to send all data that is neccessary to match the note later
    osc_client_ctrl:send(
      OscMessage("/qtroll/note", { 
        {tag="i", value=event.note_value},
        {tag="f", value=event.beat + event.beat_offset},
        {tag="f", value=event.length}, --@TODO send actual note length!!
        {tag="i", value=event.volume_value},
        {tag="i", value=event.instrument_value},
        {tag="i", value=event.line},
        {tag="i", value=event.note_column} 
      }))
    
  end     
  
end

local function print_event(e)  
  print("EVENT:")
  if e.type == 'NC' then
  print("Type: NC")
  print("Note: ".. e.note_value .."\nInstr: ".. e.instrument_value ..
        "\nPan: ".. e.panning_value .."\nVol: " .. e.volume_value ..
        "\nPattern: " .. e.pattern .. "\nTrack: " .. e.track ..
        "\nBeat / Offset: ".. e.beat .. " / " .. e.beat_offset)
  
  end     
end


function readEvents()
  local line_index = 0
  local pattern_index = renoise.song().selected_pattern_index
  local track_index = renoise.song().selected_track_index
  local iter = renoise.song().pattern_iterator:lines_in_pattern_track(
      pattern_index, track_index)
  for pos, line in iter do
     if not line.is_empty then
      --print("pattern: " .. pos.pattern .. "; line: " .. pos.line)
      -- Check each column on the line
      for npos,note_column in ipairs(line.note_columns) do
        -- something
        if not note_column.is_empty then
          local new_event = {}
          new_event.type = 'NC'
          new_event.note_value = note_column.note_value
          new_event.instrument_value = note_column.instrument_value
          new_event.panning_value = note_column.panning_value
          new_event.volume_value = note_column.volume_value
          new_event.pattern = pos.pattern
          new_event.track = pos.track
          new_event.line = pos.line
          new_event.note_column = npos
          --magic
          local lpb = renoise.song().transport.lpb
          new_event.beat = math.floor((pos.line - 1) / lpb) 
          new_event.beat_offset = (pos.line - 1 + note_column.delay_value / 256) % lpb / lpb 
          
          -- get note length
          
          local found = false
          local line_i
          local pos_line = pos.line
          for line_i = pos.line + 1, renoise.song().selected_pattern.number_of_lines, 1 do
            if not found then
              print("i: " .. line_i .. " pos.line " .. pos_line)
              local nc = renoise.song().selected_pattern_track:line(line_i):note_column(npos)
              print(nc.is_empty)
              if not nc.is_empty then 
                found = true
                new_event.length = (line_i - pos_line) / lpb
                print("length: " .. new_event.length)
              end
            end
          end
          if not found then
            new_event.length = (renoise.song().selected_pattern.number_of_lines - pos_line) / lpb
          end
          
          
          print_event(new_event)
          table.insert(events, new_event)
          --note_column:clear()
        end
      end
    end
  end
end

function writeNoteData(note)
  rprint(note)
  rprint(note.elements)
  rprint(note[2])

end

function registerNotifiers()
  if not renoise.song().selected_pattern_track_observable:has_notifier(sendNoteData) then
    renoise.song().selected_pattern_track_observable:add_notifier(sendNoteData)
  end
end

function unregisterNotifiers()
  if renoise.song().selected_pattern_track_observable:has_notifier(sendNoteData) then
    renoise.song().selected_pattern_track_observable:remove_notifier(sendNoteData)
  end
end

function toggleMenu()
  if is_running then
    if renoise.tool():has_menu_entry("Main Menu:Tools:Qtroll:Start") then
      renoise.tool():remove_menu_entry("Main Menu:Tools:Qtroll:Start")
      renoise.tool():add_menu_entry {
          name = "Main Menu:Tools:Qtroll:Stop", 
          invoke = stop
      }
    end
  else
      if renoise.tool():has_menu_entry("Main Menu:Tools:Qtroll:Stop") then
      renoise.tool():remove_menu_entry("Main Menu:Tools:Qtroll:Stop")
      renoise.tool():add_menu_entry {
          name = "Main Menu:Tools:Qtroll:Start", 
          invoke = start
      }
    end
  end
end

--------------------------------------------------------------------------------
-- menu registration
--------------------------------------------------------------------------------


renoise.tool():add_menu_entry {
   name = "Main Menu:Tools:Qtroll:Configuration", 
   invoke = function() show_config() end,
}
 
renoise.tool():add_menu_entry {
   name = "Main Menu:Tools:Qtroll:Start", 
   invoke = start
}

-- autostart
if prefs.autostart.value and not renoise.tool().app_new_document_observable:has_notifier(start) then
  renoise.tool().app_new_document_observable:add_notifier(start)
end
