import QtQuick 2.0

Item {
    id: pianoKey

    Rectangle {
        id: normal
        color: header_color
        anchors.centerIn: parent
        width: parent.width
        height: pianoHeight
        radius: 5
        smooth: true
        gradient: Gradient {
            GradientStop { position: -2 ; color: mouse.pressed ? keycolor : grid_color }
            GradientStop { position: 1 ; color: mouse.pressed ? grid_color : keycolor }
        }

        border{
            width: borderWidth
            color: mouse.pressed ? "white" : "black"
        }
    }


    MouseArea {
        id: mouse
        anchors.fill: parent
        onPressed: osc_client_ctrl.triggerNote(note);
        onReleased: osc_client_ctrl.triggerNote(note, false);
    }
}
