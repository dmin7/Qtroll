/*
    Shows our Buttons
*/

import QtQuick 2.0
import OscClient 1.0
import OscServer 1.0

Rectangle {
    color: header_color

    MyButton{
        id: start_server
        text: "Start"
        anchors.left: parent.left
        onClicked: osc_client_ctrl.sendMsg("/renoise/transport/start")
    }
    MyButton{

        id: start_client
        text: "Stop"
        anchors{left: start_server.right; leftMargin: 10}
        onClicked: osc_client_ctrl.sendMsg("/renoise/transport/stop")
    }
    MyButton{
        id: stop_client
        text: "Note test"
        anchors{left: start_client.right; leftMargin: 10}
        onClicked: osc_client_notes.sendMsg("/renoise/note")
    }
    MyButton{
        id: quit
        text: "Quit"
        anchors{right: parent.right}
        onClicked: Qt.quit()
    }
}

