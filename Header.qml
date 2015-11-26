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
        text: "start Server"
        anchors.left: parent.left
        onClicked: udp_server.start()
    }
    MyButton{

        id: start_client
        text: "start Client"
        anchors{left: start_server.right; leftMargin: 10}
        onClicked: udp_client.sendMsg("/renoise/transport/start")
    }
    MyButton{
        id: stop_client
        text: "stop Client"
        anchors{left: start_client.right; leftMargin: 10}
        onClicked: udp_client.sendMsg("/renoise/transport/stop")
    }
    MyButton{
        id: quit
        text: "Quit"
        anchors{right: parent.right}
        onClicked: Qt.quit()
    }
}

