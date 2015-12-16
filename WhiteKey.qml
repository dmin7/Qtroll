/*
    Same as Blackkey but in white
*/

import QtQuick 2.0


PianoKey {
    id: whiteKey
    property color keycolor: whitekey_color
    width: white_notes[note % noteCount][0] === 'd' || white_notes[note % noteCount][0] ===  'a' || white_notes[note % noteCount][0] ===  'g' ? noteWidth * 2: noteWidth * 1.5
    height: pianoHeight
    opacity: 1
    Text {
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.pixelSize: 9
        text: white_notes[note % noteCount] + Math.floor(note / noteCount)
    }

}
