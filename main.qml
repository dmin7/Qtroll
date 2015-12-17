import QtQuick 2.3
import QtQuick.Controls 1.2

import OscClient 1.0
import OscServer 1.0
import Pattern 1.0
import Note 1.0


// Root window, main window
ApplicationWindow {
    id: root
    visible: true
    width: 924
    height: 616
    opacity: 1
    minimumWidth: 640
    minimumHeight: 480

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

    property var selectedNotes: []

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
            pattern.add_note(val, time, len);
            pattern.count();
            note_view.model = pattern.notes;
        }

        Component.onCompleted: {
            setup(7002);
            //start();
        }
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

    // press space to select multiple keys
    // press ctrl to enable zoom with mousewheel
    Item{
        focus: true
        Keys.onPressed: {
            flickeverything.interactive = false;
            flickgrid.interactive = false;
            if (event.key === Qt.Key_Space) {
                selectArea.enabled = true
                event.accepted = true;
            }
            if (event.key === Qt.Key_Control){
                zoom.enabled = true
            }

        }
        Keys.onReleased: {
            flickeverything.interactive = true;
            flickgrid.interactive = true;
            if (event.key === Qt.Key_Space) {
                selectArea.enabled = false
                event.accepted = true;
            }
            if (event.key === Qt.Key_Control){
                zoom.enabled = false
            }
        }
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

        MouseArea {
            id: zoom
            anchors.fill: parent
            enabled: false
            onWheel: {
                 if (wheel.angleDelta.y > 0) {
                     /* crasht bei mir meistens wenn ichs größer mach und zeichnet Grid nicht, verkleinern geht */
                     if(noteWidth < 40){
                         noteWidth += 5
                         pianoHeight += 30
                     }
                 }
                 else{
                     if(noteWidth > 15){
                         noteWidth -= 5
                         pianoHeight -= 30
                     }
                 }
             }
        }

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
                    pattern.add_note(Math.round(mouseX / noteWidth), mouseY / (40*4), 1);
                    note_view.model = pattern.notes;
                }
            }

            //Shows Grid
            DrawGrid {
                id: grid
                MouseArea {
                    id: selectArea;
                    anchors.fill: parent;
                    enabled: false
                    onPressed: {
                            if (highlightItem !== null) {
                                // if there is already a selection, delete it
                                highlightItem.destroy ();
                                var lenght = selectedNotes.length
                                while (lenght-- > 0) {
                                    selectedNotes.pop();
                                }

                            }
                            // create a new rectangle at the wanted position
                            highlightItem = highlightComponent.createObject (selectArea, {
                                "x" : mouse.x, "y" : mouse.y
                            });
                    }
                    onPositionChanged: {
                        highlightItem.width = (Math.abs (mouse.x - highlightItem.x));
                        highlightItem.height = (Math.abs (mouse.y - highlightItem.y));
                    }
                    onReleased: {
                       var noteVal1 = Math.round(highlightItem.x / noteWidth);
                       var noteVal2 = Math.round((highlightItem.x + highlightItem.width) / noteWidth);
                       var noteTime1 = highlightItem.y / (40*4);
                       var noteTime2 = (highlightItem.y + highlightItem.height) / (40*4);
                       console.log("x1 : x2 " + noteVal1 + " : " + noteVal2);
                       console.log("y1 : y2 " + noteTime1 + " : " + noteTime2);
                       for (var i = 0; i < pattern.count(); i++){
                            if(pattern.notes[i].noteValue > noteVal1 && pattern.notes[i].noteValue < noteVal2){
                                if(pattern.notes[i].noteTime  > noteTime1 && pattern.notes[i].noteTime < noteTime2){
                                    selectedNotes.push(i);
                                }
                            }
                        };
                       console.log("selected elements:  " + selectedNotes);

                    }
                    property Rectangle highlightItem : null;
                    Component {
                        id: highlightComponent;

                        Rectangle {
                            id: selectRectangle
                            color: note_color;
                            opacity: 0.2;
                        }
                    }
                }
            }

            //Shows NoteData from c++ Files.

            Repeater {
                id: note_view
                //orientation: ListView.Horizontal
                height: 1000
                width: 1000
                model: pattern.notes
                delegate: Rectangle {
                    property var note_value: noteValue
                    visible: !noteDeleted

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


                    MouseArea {
                        property int oldMouseY
                        anchors.fill: parent
                        drag.target: parent
                        drag.axis: Drag.XAndYAxis
                        drag.minimumX: 0
                        drag.minimumY: 1
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true


                        onWheel: {
                            var isSelectedNote
                            for(var i = 0; i < selectedNotes.length; i++){
                                if (selectedNotes[i] === index) isSelectedNote = true;
                            }
                            if (selectedNotes.length && isSelectedNote){
                                for(var i = 0; i < selectedNotes.length; i++){
                                    if (wheel.angleDelta.y > 0) {
                                        pattern.notes[selectedNotes[i]].noteLength =
                                                pattern.notes[selectedNotes[i]].noteLength + 0.05
                                    } else if (pattern.notes[index].noteLength > 0.1) {
                                        pattern.notes[selectedNotes[i]].noteLength =
                                                pattern.notes[selectedNotes[i]].noteLength - 0.05
                                    }
                                }
                            }
                            else{
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
                            var isSelectedNote
                            for(var i = 0; i < selectedNotes.length; i++){
                                if (selectedNotes[i] === index) isSelectedNote = true;
                            }
                            if (selectedNotes.length && isSelectedNote){
                                var noteValSelected = pattern.notes[index].noteValue
                                var noteTimeSelected = pattern.notes[index].noteTime
                                for(var i = 0; i < selectedNotes.length; i++){
                                    console.log("note moved noteValue: " + pattern.notes[selectedNotes[i]].noteValue);
                                    pattern.notes[selectedNotes[i]].noteValue = Math.round(parent.x / noteWidth) + (pattern.notes[selectedNotes[i]].noteValue - noteValSelected);
                                    pattern.notes[selectedNotes[i]].noteTime = parent.y / (40*4) + (pattern.notes[selectedNotes[i]].noteTime - noteTimeSelected);
                                }
                            }
                            else {
                                pattern.notes[index].noteValue = Math.round(parent.x / noteWidth);
                                pattern.notes[index].noteTime = parent.y / (40*4)
                                console.log("note moved noteValue: " + pattern.notes[index].noteValue);
                            }
                        }

                        onDoubleClicked: {
                            // TODO: remove item
                            //pattern.notes[index].noteDeleted = true;
                            //pattern.delete_note(index);
                        }
                    }
                }
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
