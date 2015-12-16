import QtQuick 2.3
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0

import OscClient 1.0
import OscServer 1.0
import Pattern 1.0
import Note 1.0

//import "global.js" as global

// Root window, main window
ApplicationWindow {
    id: root
    visible: true
    width: 924
    height: 616
    opacity: 1
    minimumWidth: 640
    minimumHeight: 480
    color: header_color

    //Some global Propertas
    property int headerHeight: 25
    property int noteWidth: 30
    property int numberOctaves: 9
    property int borderWidth: 1
    property int pianoHeight: 166

    //Design: !(COLOR PALETTE EARLY WINTER MORNING)
    property color grid_color: "#071F26"
    property color gridline_color: "#33444F"
    property color whitekey_color: "#f8fdff"
    property color blackkey_color: "#48494b"
    property color header_color: "#28353d"
    property color button_color: "#616b71"
    property color button_gradient: "white"
    property color note_color: "#c8fdd2"



    title: qsTr("Qtroll")


    OscClient {
        id: osc_client_ctrl
        Component.onCompleted: {
            connect("127.0.0.1", 8000);
        }
    }

    OscClient {
        id: osc_client_notes
        Component.onCompleted: {
            connect("127.0.0.1", 8001);
        }
    }

    OscServer {
        id: osc_server_ctrl
        onClear: {
            console.log("qml: got clear!");
            //pattern.clear();
            pattern.notes = [];
            pattern.count();
            note_view.model = pattern.notes;
        }
        onReceiveNote: {
            console.log(val);
            pattern.add_note(val, time, len, vol, instr, line, col);
            pattern.count();
            note_view.model = pattern.notes;
        }

        onNewPattern: {
            pattern.newPattern(length, lpb);
            note_view.model = pattern.notes;
        }

        Component.onCompleted: {
            setup(7002);
            //start();
        }
    }

    Note {
        id: test
        noteValue: 12
        noteTime: 1
        noteLength: 1.2

    }

    Pattern {
        id: pattern
        patternLength: 64
        patternLpb: 4
        //notes: []
        notes: [
            Note {
                noteValue: 12
                noteTime: 1
                noteLength: 1
            },
            Note {
                noteValue: 15
                noteTime: 3
                noteLength: 3.3355
            }
        ]
    }


    //Flicks the Piano and Grid horizontally
    Flickable {
        id: flickeverything
        width: parent.width
        height: parent.height
        anchors.top: header.bottom
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: parent.height

        contentWidth: numberOctaves * 12 * noteWidth
        flickableDirection: Flickable.HorizontalFlick
        flickDeceleration: 5999
        //Flicks Grid vertically
        Flickable {
            id: flickgrid
            width: parent.width
            height: parent.height - pianoHeight
            y: pianoHeight
            contentWidth: flickgrid.width
            contentHeight: pattern.patternLength * pattern.patternLpb * 40
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    pattern.add_note(Math.round(mouseX / noteWidth), mouseY / (40*4), 1, 120, -1, -1, -1);
                    pattern.count();
                    note_view.model = pattern.notes;

                }
            }

            Image {
                source: "content/images/green.jpg"
            }

            //Shows Grid
            DrawGrid {
                id: grid
            }

            //Shows NoteData from c++ Files.

            //Row {
                Repeater {
                    id: note_view
                    //orientation: ListView.Horizontal
                    height: 1000
                    width: 1000

                    model: pattern.notes
                    delegate: Rectangle {
                        property var note_value: noteValue
                        visible: !noteDeleted
                        opacity: 0.5 + (0.5 * (noteVolume / 127))

                        height: noteLength * 40 * 4
                        border { width: 1; color: "black" }
                        color: note_color
                        width: noteWidth

                        y: noteTime * 40 * 4
                        x: (noteValue) * noteWidth

                        radius: 5
                        smooth: true
                        property var time: noteTime
                        property var value: noteValue
                        property var name: ['C-', 'C#', 'D-', 'D#', 'E-', 'F-', 'F#', 'G-', 'G#', 'A-', 'A#', 'B-']
                        Text {
                            id: text
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: name[noteValue%12] + (noteValue? Math.floor(noteValue/12) : 0)
                            font.pixelSize: 8
                        }

                        HueSaturation {
                            anchors.fill: parent
                            source: parent
                            saturation: - 1 + (0.7 * Math.min(noteVolume) / 127)
                            lightness: - 0.5 + (0.7 * Math.min(noteVolume, 127) / 127)
                            hue: -1 + (noteValue%12 / 24)
                        }

                        MouseArea {
                            property int oldMouseY
                            anchors.fill: parent
                            drag.target: parent
                            drag.axis: Drag.XAndYAxis
                            drag.minimumX: noteWidth
                            drag.minimumY: 1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            hoverEnabled: true


                            onWheel: {
                                if (wheel.modifiers & Qt.ControlModifier) {
                                    if (wheel.angleDelta.y > 0) {
                                        pattern.notes[index].noteVolume =
                                                Math.min(pattern.notes[index].noteVolume + 1, 127)
                                    } else if (pattern.notes[index].noteVolume > 0) {
                                        pattern.notes[index].noteVolume =
                                                pattern.notes[index].noteVolume - 1
                                    }
                                } else {

                                    if (wheel.angleDelta.y > 0) {
                                        pattern.notes[index].noteLength =
                                                pattern.notes[index].noteLength + 0.05
                                    } else if (pattern.notes[index].noteLength > 0.1) {
                                        pattern.notes[index].noteLength =
                                                pattern.notes[index].noteLength - 0.05
                                    }
                                }
                            }

                            onReleased: {
                                // manual snap to grid
                                parent.x = Math.round(parent.x / noteWidth) * noteWidth;
                                // adjust model
                                pattern.notes[index].noteValue = Math.round(parent.x / noteWidth);
                                pattern.notes[index].noteTime = parent.y / (40*4)
                                console.log("note moved noteValue: " + pattern.notes[index].noteValue);
                            }

                            onDoubleClicked: {
                                // TODO: remove item
                                pattern.notes[index].noteDeleted = true;
                            }
                        }
                    }
                //}
            }

        }

        //Piano Part
        KeyBoard{
            id: piano
        }
    }

    //Scrollbar from Qt, disappears when not used, looks better than ScrollView
    ScrollBar {
            scrollArea: flickgrid
            width: 12
            anchors.top: parent.top
            anchors.bottom: parent.bottom
    }

    //top Part of view with buttons and stuff
    Header{
        id: header
        width: root.width
        height: headerHeight
    }
}
