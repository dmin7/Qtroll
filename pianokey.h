#ifndef PIANOKEY_H
#define PIANOKEY_H
#include <QWidget>
class PianoKey : public QWidget
{
    Q_OBJECT
    public:
        explicit PianoKey(bool blackKey, QWidget *parent = 0);
    private:
        bool isPressed, isBlack;
    protected:
        void paintEvent(QPaintEvent *);
        void mousePressEvent(QMouseEvent *);
        void mouseReleaseEvent(QMouseEvent *);
}
;
#endif // PIANOKEY_H
