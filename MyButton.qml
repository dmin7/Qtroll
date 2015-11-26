/*
    Beatiful Button with sick gradient
*/

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button {
    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 25
            radius: 4
            gradient: Gradient {
                GradientStop { position: 0 ; color: control.pressed ? button_color : button_gradient }
                GradientStop { position: 1 ; color: control.pressed ? button_gradient : button_color }
            }
        }
    }
}

