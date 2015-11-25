import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    property int buttonWidth: 100

    color: "lightsteelblue"

    ListModel {
        id: buttonModel
        ListElement {
              name: "OSC Button 1"
              run: "startServer()"
        }
        ListElement {
              name: "OSC Button 2"
              run: "startClient()"
        }
        ListElement {
              name: "OSC Button 3"
              run: "Exit()"
        }
        ListElement {
              name: "OSC Button 4"
              run: "DoSth()"
        }
    }

    Component {
        id: buttonDelegate
        Button{
            id: button
            height: headerHeight * 0.6
            text: name + ": " + run
        }
    }
    ListView {
            width: parent.width
            height: parent.height
            orientation: ListView.Horizontal
            layoutDirection: Qt.LeftToRight
            model: buttonModel
            delegate: buttonDelegate
            spacing: 10
            anchors{top: parent.top; bottom: parent.bottom; left: parent.left}

    }

}

