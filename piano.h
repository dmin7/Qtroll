#ifndef WIDGET_H
#define WIDGET_H
#include <QWidget>
#include <QHBoxLayout>
#include "pianokey.h"

class Piano : public QWidget
{
    Q_OBJECT
    public:
        explicit Piano(QWidget *parent = 0);
        ~Piano();
    private:
        QHBoxLayout *layout;
        void arrangeBlackKeys();
        QList<PianoKey *> whiteKeys;
        QList<PianoKey *> blackKeys;
        QList<int> blackLocations;
    protected:
        void resizeEvent(QResizeEvent *);
}
;
#endif // WIDGET_H
