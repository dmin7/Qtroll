/*
    Piano Part of the Pianoroll
*/

import QtQuick 2.0

Item {
    id: piano
    property var white_notes :  ['c-', 'd-', 'e-', 'f-', 'g-', 'a-', 'b-'];
    property var black_notes :  ['', 'c#', '', 'd#', '','', 'f#', '', 'g#', '', 'a#', ''];
    property int noteCount : 7 //per octave
    ListModel {
        id: keys

        //Adds Keys to Model
        Component.onCompleted: {
            for (var i = 0; i < (12 * numberOctaves); i++) {
                keys.append({note: i});
            };
        }
    }

    Rectangle {
        color: header_color
        height: pianoHeight

        Row {
            id: piano_row
            anchors.fill: parent
            height: pianoHeight
            Repeater {
                model: keys
                delegate: WhiteKey{}
            }
        }

        Row {
            id: piano_row2
            anchors.fill: parent
            height: pianoHeight
            //anchors.leftMargin: noteWidth
            Repeater {
                model: keys
                delegate: BlackKey{}
            }
        }
    }
}
