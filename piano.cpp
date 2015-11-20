#include "piano.h"

#include <QLabel>
#include <QPoint>
Piano::Piano(QWidget *parent) : QWidget(parent) {
    layout = new QHBoxLayout(this);
    for (int octave = 0; octave < 7; octave++){
        // weiße Tasten erstellen und setzen
        for (int x = octave * 7; x < 7 + octave * 7 ; ++x) {
            whiteKeys << new PianoKey(0, this);
            layout->addWidget(whiteKeys[x]);
        }
        // schwarze Tasten erstellen
        for (int x = 0; x < 5; ++x){
            blackKeys << new PianoKey(1, this);
        }
        blackLocations << octave * 7 << 1 + octave * 7 << 3 + octave * 7 << 4 + octave * 7 << 5 + octave * 7;
    }
    resize(1500, 100);
    //schwarze Tasten setzen
    arrangeBlackKeys();
}

Piano::~Piano() {
}

void Piano::arrangeBlackKeys() {
    int keyWidth = whiteKeys[0]->width() / 1.6;
    int keyHeight = whiteKeys[0]->height() / 1.6;
    int offset = whiteKeys[0]->width() / 1.5;
    int xLocation, yLocation = whiteKeys[0]->pos().y();
    for (int x = 0; x < blackKeys.length(); ++x) {
        xLocation = blackLocations[x];
        blackKeys[x]->resize(keyWidth, keyHeight);
        blackKeys[x]->move(whiteKeys[xLocation]->pos().x() + offset, yLocation);
    }
}

void Piano::resizeEvent(QResizeEvent *) {
    arrangeBlackKeys();
}
