/*
    Same as Whitekey, but in black
*/

import QtQuick 2.0

PianoKey {
    id: blackKey
    property color keycolor: blackkey_color
    height: black_notes[note % 12][1] === '#' ? pianoHeight * 0.7 : 0.000001
    opacity: black_notes[note % 12][1] === '#' ? 1 : 0
    width: noteWidth
    Text {
        color: "#FFFFF0"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.pixelSize: 9
        text: black_notes[note % 12] + Math.floor(note / 12)
    }
}
