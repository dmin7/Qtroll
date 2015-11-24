import QtQuick 2.0


Item {
    id: pianoKey

    property int fadeDuration: 30


    Rectangle {
        id: normal
        color: keycolor
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: 5
        smooth: true
        border{
            width: borderWidth
            color: mouse.pressed ? "white" : "black"
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
    }
}
