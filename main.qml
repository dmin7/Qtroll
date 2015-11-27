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
    property int headerHeight: 25
    property int noteWidth: 30
    property int numberOctaves: 9
    property int borderWidth: 1
    property int pianoHeight: 200

    //Design: COLOR PALETTE EARLY WINTER MORNING
    property color grid_color: "#42545f"
    property color gridline_color: "#33444F"
    property color whitekey_color: "#f8fdff"
    property color blackkey_color: "#48494b"
    property color header_color: "#28353d"
    property color button_color: "#616b71"
    property color button_gradient: "white"
    property color note_color: "#c8fdd2"



    title: qsTr("Qtroll")


    OscClient {
        id: osc_client_ctrl
        Component.onCompleted: {
            connect("127.0.0.1", 8000);
        }
    }

    OscClient {
        id: osc_client_notes
        Component.onCompleted: {
            connect("127.0.0.1", 8001);
        }
    }

    OscServer {
        id: osc_server_ctrl
        Component.onCompleted: {
            setup(7000);
        }
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
        flickDeceleration: 5999
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
                        color: note_color
                        width: noteWidth

                        radius: 5
                        smooth: true
                        property var time: noteTime
                        property var value: noteValue
                        property var name: ['C-', 'C#', 'D-', 'D#', 'E-', 'F-', 'F#', 'G-', 'G#', 'A-', 'A#', 'B-']
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
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
                                    property: "y"; to: dispTrans.ViewTransition.item.y  + Math.round(dispTrans.ViewTransition.item.time*40*4)
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
