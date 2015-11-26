/*
    Same as Whitekey, but in black
*/

import QtQuick 2.0

PianoKey {
    id: blackKey
    width: noteWidth
    height: parent.height * 0.7
    opacity: notes[note % noteCount][1] === '#' ? 1 : 0
    Text {
        color: "#FFFFF0"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.pixelSize: 9
        text: notes[note % noteCount] + Math.round((note - note % noteCount) / noteCount)
    }

    property color keycolor: blackkey_color
}
