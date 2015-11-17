import QtQuick 2.3
import QtQuick.Controls 1.2

import OscClient 1.0
import OscServer 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("qtroll")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    OscClient {
        id: udp_client
    }

    OscServer {
        id: udp_server
    }

    Column {
        anchors.centerIn: parent
        spacing: parent.width/6

        Button {
            id: btn_start
            text: "start!"
            onClicked: udp_client.sendMsg("/renoise/transport/start")
        }

        Button {
            id: btn_starts
            text: "start serv!"
            onClicked: udp_server.start()
        }

        Button {
            id: btn_stop
            text: "stop!"
            onClicked: udp_client.sendMsg("/renoise/transport/stop")
        }

        Button {
            id: btn_quit
            text: "quit!"
            onClicked: Qt.quit()
        }
    }
}

