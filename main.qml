import QtQuick 2.3
import QtQuick.Controls 1.2

import OscClient 1.0
import OscServer 1.0

ApplicationWindow {
    visible: true
    width: 840
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


    Rectangle {
        id: mainwondow
        anchors.fill: parent

        ListModel{
            id: noten
            ListElement{note: "c0"}
            ListElement{note: "d0"}
            ListElement{note: "e0"}
            ListElement{note: "f0"}
            ListElement{note: "g0"}
            ListElement{note: "a0"}
            ListElement{note: "h0"}
            ListElement{note: "c1"}
            ListElement{note: "d1"}
            ListElement{note: "e1"}
            ListElement{note: "f1"}
            ListElement{note: "g1"}
            ListElement{note: "a1"}
            ListElement{note: "h1"}
            ListElement{note: "c2"}
            ListElement{note: "d2"}
            ListElement{note: "e2"}
            ListElement{note: "f2"}
            ListElement{note: "g2"}
            ListElement{note: "a2"}
            ListElement{note: "h2"}
            ListElement{note: "c3"}
            ListElement{note: "d3"}
            ListElement{note: "e3"}
            ListElement{note: "f3"}
            ListElement{note: "g3"}
            ListElement{note: "a3"}
            ListElement{note: "h3"}
            ListElement{note: "c4"}
            ListElement{note: "d4"}
            ListElement{note: "e4"}
            ListElement{note: "f4"}
            ListElement{note: "g4"}
            ListElement{note: "a4"}
            ListElement{note: "h4"}
            ListElement{note: "c5"}
            ListElement{note: "d5"}
            ListElement{note: "e5"}
            ListElement{note: "f5"}
            ListElement{note: "g5"}
            ListElement{note: "a5"}
            ListElement{note: "h5"}
        }

        Component{
            id: key_white
            Rectangle {
                width: 20
                height: 80
                color: "#FFFFF0"
                border { width: 1; color: "black" }
                radius: 3
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    text: note
                }
            }
        }

        Row {
            id: piano_row
            anchors.fill: parent
            Repeater {
                model: noten
                delegate: key_white
            }
        }
        //Einzelnen Elemente ansprechen: Component.onCompleted: piano_row.children[2].color="black"

    }

    /*
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
    */
}

