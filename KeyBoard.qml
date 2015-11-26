/*
    Piano Part of the Pianoroll
*/

import QtQuick 2.0

Item {
    id: piano
    property var notes :  ['c-', 'c#', 'd-', 'd#', 'e-', 'f-', 'f#', 'g-', 'g#', 'a-', 'a#', 'b-'];
    property int noteCount : notes.length
    ListModel {
        id: keys

        //Adds Keys to Model
        Component.onCompleted: {
            for (var i = 0; i < (noteCount * numberOctaves); i++) {
                keys.append({note: i});
            };
        }
    }

    Rectangle {
        height: pianoHeight
        Component {
            id: delegate
            Rectangle{
                width: noteWidth
                height: pianoHeight
                color: grid_color
                BlackKey{}
                WhiteKey{}

            }
        }
        Row {
            id: piano_row
            anchors.fill: parent
            Repeater {
                model: keys
                delegate: delegate
            }
        }
    }
}
