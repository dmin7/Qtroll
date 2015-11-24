import QtQuick 2.0

PianoKey {
    id: whiteKey
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

    property string keycolor: "#FFFFF0" // ivory

    /*
    function getKeywidth() {
        if(notes[note % noteCount][0] === 'g' || notes[note % noteCount][0] === 'a' || notes[note % noteCount][0] === 'd') {
            return noteWidth * 2 - borderWidth
        }
        else{
            return noteWidth * 1.5 - borderWidth
        }
    }
    */

}
