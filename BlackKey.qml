/*
    Same as Whitekey, but in black
*/

import QtQuick 2.0

PianoKey {
    id: blackKey
    height: pianoHeight * 0.7
    opacity: black_notes[note % 12][1] === '#' ? 1 : 0
    width: noteWidth
    //width: black_notes[note % 12][1] === '#' ? noteWidth : 0
    Text {
        color: "#FFFFF0"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.pixelSize: 9
        text: black_notes[note % 12] + Math.round((note - note % 12) / 12)
    }
    property color keycolor: blackkey_color
}
