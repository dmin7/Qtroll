import QtQuick 2.3
import QtQuick.Controls 1.2

import OscClient 1.0
import OscServer 1.0

//import "global.js" as global

ApplicationWindow {
    id: rollwin
    visible: true
    width: 924
    height: 616
    opacity: 1
    minimumWidth: 640
    minimumHeight: 480
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

        Menu {
            title: qsTr("OSC")
            MenuItem {
                text: qsTr("&start")
                onTriggered: udp_client.sendMsg("/renoise/transport/start")
            }
            MenuItem {
                text: qsTr("start serv")
                onTriggered: udp_server.start()
            }
            MenuItem {
                text: qsTr("&stop")
                onTriggered: udp_client.sendMsg("/renoise/transport/stop")
            }
            MenuItem {
                text: qsTr("quit")
                onTriggered: Qt.quit()
            }
        }

    }

        OscClient {
        id: osc_client_ctrl
    }

        OscServer {
        id: osc_server_ctrl
    }

        OscClient {
        id: osc_client_notes
    }

        OscServer {
        id: osc_server_notes
    }

        Flickable {
        id: flickeverything
        width: parent.width
        height: parent.height
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: flickeverything.height
        contentWidth: noten.count * 30 + noten.count * maingrid.spacing
        flickableDirection: Flickable.HorizontalFlick
        Flickable {
            id: flickgrid
            x: 0
            y: 100
            width: parent.width
            height: parent.height - 100
            contentWidth: flickgrid.width
            contentHeight: 10000
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick

                Rectangle {
                id: gridbeat
                anchors.left: parent.left
                anchors.right: parent.right
                color: "green"
                Grid {
                    id: maingrid
                    y: 0
                    anchors.bottomMargin: 0
                    anchors.fill: parent
                    columns: noten.count
                    spacing: 3
                    Repeater {
                        y: 0
                        model: 100 * noten.count
                        Rectangle {
                            width: 30
                            height: piano.height
                            color: "lightgrey"
                            Repeater {
                                model: 4
                                Rectangle {
                                    width: 30
                                    y: index * piano.height / 4
                                    height: piano.height / 4
                                    color: "#00000000"
                                    border.color: "#000000"
                                }
                            }

                        }

                    }
                }
            }
        }

        Rectangle {
            id: piano
            height: 100
            color: rollwin.color
            ListModel {
                id: noten
                ListElement {
                    note: "c0"
                }
                ListElement {
                    note: "d0"
                }
                ListElement {
                    note: "e0"
                }
                ListElement {
                    note: "f0"
                }
                ListElement {
                    note: "g0"
                }
                ListElement {
                    note: "a0"
                }
                ListElement {
                    note: "h0"
                }
                ListElement {
                    note: "c1"
                }
                ListElement {
                    note: "d1"
                }
                ListElement {
                    note: "e1"
                }
                ListElement {
                    note: "f1"
                }
                ListElement {
                    note: "g1"
                }
                ListElement {
                    note: "a1"
                }
                ListElement {
                    note: "h1"
                }
                ListElement {
                    note: "c2"
                }
                ListElement {
                    note: "d2"
                }
                ListElement {
                    note: "e2"
                }
                ListElement {
                    note: "f2"
                }
                ListElement {
                    note: "g2"
                }
                ListElement {
                    note: "a2"
                }
                ListElement {
                    note: "h2"
                }
                ListElement {
                    note: "c3"
                }
                ListElement {
                    note: "d3"
                }
                ListElement {
                    note: "e3"
                }
                ListElement {
                    note: "f3"
                }
                ListElement {
                    note: "g3"
                }
                ListElement {
                    note: "a3"
                }
                ListElement {
                    note: "h3"
                }
            }

            Component {
                id: key_white
                Rectangle {
                    width: 30
                    height: parent.height
                    color: "#FFFFF0" // ivory
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        text: note
                    }
                }
            }
            Row {
                id: piano_row
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent
                spacing: 3
                Repeater {
                    model: noten
                    delegate: key_white
                }
            }

        }

    }

    /* wtf???? nice animations i guess?
    ScrollView{

           x: 0

           y: 0

           width: parent.width

           height: parent.height

           opacity: 1

           highlightOnFocus: false

           frameVisible: false

           Flickable {

               id: flickable1

               x: 0

               y: 276

               width: 640

               height: 204

               enabled: true

               interactive: true

               contentWidth: contentItem.childrenRect.width

               contentHeight: 260

               boundsBehavior: Flickable.StopAtBounds

               Rectangle {

                   id: rectangle1

                   x: 0

                   y: 4

                   width: 1000

                   height: 1000

                   gradient: Gradient {

                       GradientStop {

                           position: 0

                           color: "#ffffff"

                       }

                       GradientStop {

                           position: 1

                           color: "#000000"

                       }

                   }
                   Row {
                       id: piano_roww

                       ListView {
                           orientation: ListView.Horizontal
                           height: 1000
                           width: 1000

                           model: noteData
                           delegate: Rectangle {
                               height: noteLength * 100
                               border { width: 1; color: "black" }
                               width: 20
                               property var time: noteTime
                               Text { text: "" + noteValue }
                           }
                           populate: Transition {
                               id: dispTrans
                               NumberAnimation {
                                   property: "y"; to: dispTrans.ViewTransition.item.y  + Math.round(dispTrans.ViewTransition.item.time*100)
                                   easing.type: Easing.OutBounce; duration: 500
                               }
                           }
                       }
                   }

               }

           }

       }
       */


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

/*
    Flickable {
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        height: 80
        width: 100
        contentHeight: 400
        contentWidth: 400
    Rectangle {
        id: piano
        width: parent.width
        height: 100
        color: Qt.rgba(0,0,0,0)
        property int last_x: 0

        ListModel{
            id: noten
            Repeater {
                model: 5
                ListElement{note: index}
            }
        }

        Component{
            id: key_white


            Rectangle {
                property var note_names: ["c-", "c#", "d-", "d#", "e-", "f-", "f#"]
                property var colors: ["white", "black", "white", "black", "white", "white"]
                property var offsets: [0, 10, 35, 200, 70, 105 ]
                property int octave: Math.round(note/12)
                property var color_: colors[note % 12]
                property var last_color: ((note%12)==0)? "white": [colors[(note-1)%12]]
                width: color_ == "black"? 20 : 35
                height: color_ == "black"? 70 : 100
                color: color_; // "#FFFFF0" // ivory
                border { width: 1; color: "black" }

                layer.enabled: color_ === "black"
                //x: parent.x + offsets[note%12]

                function setOffset() {

                    var color = colors[note % 12]
                    var last_note_color
                    if (note %12 == 0){
                        last_note_color = "white"
                    } else {
                        last_note_color = colors[(note-1)%12]
                    }
                    if (color == "black") {
                                return piano.last_x - 20
                    } else if (color == "white") {
                        parent.parent.last_x += 35
                        return piano.last_x
                    }
                }

                radius: 3
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: colors[note %12] == "white"? "black" : "white"
                    text: note_names[note % 12] + Math.round(note / 12)
                }

            }
        }

        Row {
            id: piano_row
            transformOrigin: Item.Center
            anchors.left: parent.left
            anchors.leftMargin: 520
            anchors.right: parent.right
            anchors.rightMargin: -120
            PathView {
                model: noten
                delegate: key_white
                path: Path {
                    startX: 20; startY: 50
                    PathLine { x: 25; y: 50 }
                    PathLine { x: 45; y: 50 }
                    PathLine { x: 70; y: 50 }
                    PathLine { x: 105; y: 50 }
                }
            }
        }
    }
*/
