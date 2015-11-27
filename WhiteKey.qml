/*
    Same as Blackkey but in white
*/

import QtQuick 2.0


PianoKey {
    id: whiteKey
    property color keycolor: whitekey_color
    //if Note is no Whitekey, set Width = 0 and Opacity = 0
    width: notes[note % noteCount][1] === '#' ? 0 : noteWidth
    height: parent.height
    opacity: notes[note % noteCount][1] === '#' ? 0 : 1
    Text {
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        font.pixelSize: 9
        text: notes[note % noteCount] + Math.round((note - note % noteCount) / noteCount)
    }
}
