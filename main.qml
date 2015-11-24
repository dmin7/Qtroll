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

    property int noteWidth: 20
    property int numberOctaves: 9
    property int borderWidth: 1
    property int pianoHeight: 100

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
        contentWidth: numberOctaves * 12 * noteWidth
        flickableDirection: Flickable.HorizontalFlick
        Flickable {
            id: flickgrid
            x: 0
            y: pianoHeight
            width: parent.width
            height: parent.height - pianoHeight
            contentWidth: flickgrid.width
            contentHeight: 10000
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick

            NotesView {
                id: grid
            }

            Row {
                id: piano_row

                ListView {
                    orientation: ListView.Horizontal
                    height: 1000
                    width: 1000

                    model: noteData
                    delegate: Rectangle {
                        height: noteLength * 40 * 4
                        border { width: 1; color: "black" }
                        width: noteWidth
                        property var time: noteTime
                        property var value: noteValue
                        property var name: ['C-', 'C#', 'D-', 'D#', 'E-', 'F-', 'F#', 'G-', 'G#', 'A-', 'A#', 'B-']
                        Text {
                            text: name[noteValue%12] + (noteValue? Math.round(noteValue/12) : 0)
                            font.pixelSize: 8
                        }
                        MouseArea {
                            anchors.fill: parent
                            drag.target: parent
                            drag.axis: Drag.XAndYAxis
                            drag.minimumX: noteWidth
                            drag.minimumY: 1
                            onReleased: {
                                parent.x = Math.round(parent.x / noteWidth) * noteWidth ;
                            }
                        }
                    }

                    populate: Transition {
                        id: dispTrans
                        SequentialAnimation {
                            loops: Animation.Infinite
                            ParallelAnimation {
                                NumberAnimation {
                                    property: "y"; to: dispTrans.ViewTransition.item.y  + Math.round(dispTrans.ViewTransition.item.time*100)
                                    easing.type: Easing.OutBounce; duration: 0
                                }
                                NumberAnimation {
                                    property: "x"; to: Math.round(dispTrans.ViewTransition.item.value*noteWidth)
                                    easing.type: Easing.OutBounce; duration: 0
                                }
                            }
                        }
                    }
                }
            }
        }

        KeyBoard{}
    }
}
