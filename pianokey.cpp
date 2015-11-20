#include "pianokey.h"
#include <QPainter>

PianoKey::PianoKey(bool blackKey, QWidget *parent):
    QWidget(parent),isPressed(0), isBlack(blackKey) {
}
void PianoKey::paintEvent(QPaintEvent *) {
    QPainter painter(this);
    QColor drawColor;
    if (isBlack){
        if (isPressed){
            drawColor = Qt::gray;
        }
        else{
            drawColor = Qt::black;
        }
    }
    else{
        if (isPressed){
        drawColor = Qt::lightGray;
        }
        else{
            drawColor = "#FFFFF0";
        }
    }
    painter.fillRect(rect(), drawColor);
}
void PianoKey::mousePressEvent(QMouseEvent *) {
    isPressed = 1;
    repaint();
}
void PianoKey::mouseReleaseEvent(QMouseEvent *) {
    isPressed = 0;
    repaint();
}
