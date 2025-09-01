Qtroll – External Piano Roll Prototype for Renoise
=================================================

Qtroll is an experimental university project (2017) originating from a “Cross‑platform Development with Qt” elective. It explores building an external, classic piano‑roll style MIDI editor that interfaces (via OSC) with the tracker‑based DAW [Renoise](https://www.renoise.com/). It consists of:

1. A Qt / QML desktop application that renders and edits note events visually (piano roll style).
2. A Renoise scripting tool (Lua) that exports the currently selected pattern / track over OSC and receives edits back.

Status: archival / prototype quality. The code works as a proof of concept, but is not production ready (hard‑coded ports, missing error handling, limited synchronization and undo, no packaging). During the course we ran quick builds on Windows & Linux desktops and an Android device (Qt Quick) to validate portability. Pull requests welcome if you feel like modernizing it.

---

## Motivation / Background

Trackers favor fast, keyboard oriented, line based editing. Many other DAWs provide a piano roll for more immediate, “played” MIDI manipulation. Qtroll attempts to bridge the two by letting Renoise users glance and edit notes in a more spatial (pitch vs. time) layout without modifying Renoise itself beyond a scripting tool.

Communication is handled with OSC (Open Sound Control). The Renoise tool scans the selected pattern track, converts note data to events (value, time, length, velocity, instrument, line & column) and sends them to the Qt app. The app displays and allows interactive editing; changes may be sent back (partially implemented).

## Features (Implemented)

- QML piano roll rendering of notes (vertical time, horizontal pitch – can scroll & zoom)
- Add note (double click in grid)
- Move notes (drag)
- Change note length (mouse wheel over a note; supports multi‑selection)
- Delete note (double click existing note – marks deleted and removes)
- Multi‑selection rectangle (hold Space to drag a selection box)
- Basic undo stash for note set
- OSC based import of the current Renoise pattern / LPB (lines per beat) & notes

## Planned / Not Implemented (Ideas from original spec)

- Quantization & advanced edit operations
- Event editor (per‑note properties view)
- Full round‑trip synchronization (all edits reliably pushed back to Renoise)
- Transport control (play/stop) via OSC
- Stand‑alone MIDI mode (no Renoise)

## Architecture Overview

Component summary:

- `re.dread.Qtroll.xrnx/` – Renoise scripting tool (Lua). Registers menu entries, sets up OSC client(s)/server, exports pattern notes. Key files:
    - `main.lua` – startup, pattern scanning (`readEvents`), sending OSC messages.
    - `osc_client.lua`, `osc_server.lua` – thin UDP wrappers.
    - `preferences.lua` – default host & port setup (writes `preferences.xml`).
- Qt Application (C++ / QML):
    - `main.cpp` registers QML types (`OscClient`, `OscServer`, `Pattern`, `Note`).
    - `OscClient.*`, `OscServer.*` wrap oscpack UDP send/receive.
    - `pattern.*`, `note.*` define the note data model exposed to QML.
    - QML UI (`main.qml` + component QML files) implements piano roll UI and interaction logic.
    - `oscpack/` vendored library sources (no external dependency during build).

Data Flow (current prototype):

Renoise (Lua) → (OSC / several messages: /qtroll/pattern_length, /qtroll/lpb, /qtroll/note) → Qt App Pattern Model → QML Display & Edits → (partially) OSC back to Renoise.

## OSC Endpoints (Prototype)

From Renoise tool to Qt app (control channel):

- `/qtroll/clear` – start a fresh pattern load
- `/qtroll/pattern_length` (i int) – number of lines
- `/qtroll/lpb` (i int) – lines per beat
- `/qtroll/note` (i, f, f, i, i, i, i) – value, beat(float), length(float beats), volume, instrument, line, column

From Qt app to (intended) Renoise (notes channel):

- Not finalized – `OscClient::sendNote` serializes a note, but matching Lua receiver logic is not fully implemented in this snapshot.

Ports: The C++ side currently hard‑codes two outgoing client connections (8000, 8001) and one server listen port (7002). The Lua preferences default to different ports (e.g. 8004/8005/8006 originally, overridden to 7002/8001 in `preferences.xml`). You may need to align these manually (see “Configuration”).

## Building the Qt Application

Prerequisites:

- Qt 5.x with Qt Quick modules (tested originally circa Qt 5.5)
- A C++11 capable compiler (MSVC, MinGW, Clang, GCC)
- No separate oscpack install needed (sources bundled)

Steps (qmake):

1. Open `qtroll.pro` in Qt Creator (or run `qmake` then your platform build tool).
2. Build the project (Release or Debug).
3. Run the generated executable (it loads `main.qml` via the resource file `qml.qrc`).

If you migrate to CMake (modern Qt), you can add the oscpack sources similarly; contribution welcome.

## Installing the Renoise Tool

1. Copy the folder `re.dread.Qtroll.xrnx` into your Renoise user tools directory, e.g.:
     - Windows: `%APPDATA%/Renoise*/Scripts/Tools/`
2. (Re)start Renoise – it should list “Qtroll” under `Tools > Qtroll`.
3. On first run, `preferences.lua` writes a `preferences.xml` with ports/host. Adjust to match the Qt app.
4. Use `Tools > Qtroll > Start` to begin exporting the selected pattern. Switching tracks or patterns triggers re‑export (via observables).

## Configuration / Port Alignment

Edit `re.dread.Qtroll.xrnx/preferences.xml` (or change defaults in `preferences.lua`) to match what the Qt app expects. Alternatively, modify the hard‑coded defaults in:

- `main.qml` (search for `OscClient {` blocks & `OscServer setup(...)`)
- `OscClient.h` (SERVER_IP / SERVER_PORT – legacy remnants)

For a quick test you can set every component to localhost and these example ports:

- Control channel Renoise → Qt: 8000
- Notes channel (future use): 8001
- Qt listening port (Qt server receiving edits): 7002

Ensure firewalls allow UDP on the chosen ports.

## Using the Piano Roll

- Drag horizontally to scroll pitch range, vertically within grid to scroll time.
- Double click in empty grid space to insert a note.
- Drag a note to move (snaps pitch to semitones, time is continuous in beats / subdivisions).
- Mouse wheel over a note adjusts its length (supports multi‑selection).
- Hold Space and drag to create a selection rectangle; selected notes get a bold border.
- Ctrl+Z (while a note item has focus) triggers the rudimentary undo (`Pattern::undo_change`).
- Double click a note to delete it.

## Limitations / Known Issues

- Incomplete return path to Renoise (edits are not persisted back into the pattern reliably).
- Port configuration inconsistency between Lua and C++ layers (manual alignment needed).
- Minimal error handling & no robust threading shutdown (OSC server thread).
- Zoom code is fragile (increasing `noteWidth` beyond ~40 may crash or fail to redraw, per in‑code comment).
- No automated tests; undo is simplistic (single stash).

## Future Modernization Ideas

- Replace qmake with CMake and update to Qt 6.
- Implement a proper bidirectional OSC schema for note CRUD + pattern diffs.
- Add velocity, instrument editing UI, quantization & grid snapping.
- Integrate with Renoise transport controls.
- Provide a standalone MIDI import/export mode.
- Unit tests for model (Pattern / Note) and OSC message formatting.

## Contributing

Because this is a frozen academic prototype, large architectural changes are fine as long as the original functionality (import & display notes from Renoise) remains demonstrable. Please open an issue first if altering OSC message formats.

## License

MIT – see `LICENSE`.

## Credits

Original student team (2017): dmin7, vir2el, robin (names not fully preserved). Uses the embedded [oscpack](https://github.com/rossbencina/oscpack) library (license included in its directory).

## Historic German Summary (Original README Excerpt)

Das Projekt implementiert ein externes Pianoroll‑Interface für Renoise mittels OSC. Notendaten eines Patterns/Tracks werden gesendet, in einer Qt Anwendung dargestellt und bearbeitet; Änderungen sollen zurückgeschickt werden. Implementiert wurden: Datenmodell, Darstellung, grundlegende Editierfunktionen und Synchronisierung (einseitig) mit Renoise.

---

Happy hacking & feel free to revive this! :)
