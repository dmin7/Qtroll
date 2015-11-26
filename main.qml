import QtQuick 2.3
import QtQuick.Controls 1.2

import OscClient 1.0
import OscServer 1.0

//import "global.js" as global

// Root window, main window
ApplicationWindow {
    id: root
    visible: true
    width: 924
    height: 616
    opacity: 1
    minimumWidth: 640
    minimumHeight: 480

    //Some global Propertas
    property int headerHeight: 30
    property int noteWidth: 30
    property int numberOctaves: 9
    property int borderWidth: 1
    property int pianoHeight: 200

    //Design: COLOR PALETTE EARLY WINTER MORNING
    property color grid_color: "#C5C7B6"
    property color gridline_color: "#222028"
    property color whitekey_color: "#FFF8D3"
    property color blackkey_color: "#222028"
    property color header_color: "#C5C7B6"
    property color button_color: "#FFF8D3"
    property color button_gradient: "white"



    title: qsTr("qtroll")

    /* Urgh Ugly
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
    }*/

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

    //Flicks the Piano and Grid horizontally
    Flickable {
        id: flickeverything
        width: parent.width
        height: parent.height
        anchors.top: header.bottom
        boundsBehavior: Flickable.StopAtBounds
        contentHeight: flickeverything.height
        contentWidth: numberOctaves * 12 * noteWidth
        flickableDirection: Flickable.HorizontalFlick
        flickDeceleration: 2999
        //Flicks Grid vertically
        Flickable {
            id: flickgrid
            width: parent.width
            height: parent.height - pianoHeight
            y: pianoHeight
            contentWidth: flickgrid.width
            contentHeight: 128 * 40
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick

            //Shows Grid
            DrawGrid {
                id: grid
            }

            //Shows NoteData from c++ Files.
            Row {
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
                            text: name[noteValue%12] + (noteValue? Math.floor(noteValue/12) : 0)
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

        //Piano Part
        KeyBoard{
            id: piano
        }
    }

    //Scrollbar from Qt, disappears when not used, looks better than ScrollView
    ScrollBar {
            scrollArea: flickgrid
            width: 12
            anchors.top: parent.top
            anchors.bottom: parent.bottom
    }

    //top Part of view with buttons and stuff
    Header{
        id: header
        width: root.width
        height: headerHeight
    }
}
