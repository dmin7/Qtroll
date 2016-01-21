#ifndef PATTERN_H
#define PATTERN_H

#include <QObject>
#include <QQmlListProperty>
#include <QList>

#include "note.h"

class Pattern : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float patternLength READ patternLength WRITE setPatternLength NOTIFY patternLengthChanged)
    Q_PROPERTY(int patternLpb READ patternLpb WRITE setPatternLpb NOTIFY patternLpbChanged)
    Q_PROPERTY(QQmlListProperty<Note> notes READ notes NOTIFY notesChanged)
public:
    /* constructors */
    explicit Pattern(QObject *parent = 0);

    /* qml accessible methods */
    Q_INVOKABLE void clear();
    Q_INVOKABLE int count();
    Q_INVOKABLE void newPattern(int length, int lpb);
    Q_INVOKABLE void add_note(int val, float time, float len, int vol, int instr, int line, int col, int action);
    Q_INVOKABLE void delete_note(int index);
    
    Q_INVOKABLE void undo_change();


    /* setters and getters */
    float patternLength();
    int patternLpb();
    void setPatternLength(float length);
    void setPatternLpb(int lpb);
    QQmlListProperty<Note> notes();
    Note *note(int index) const;



signals:
    void patternLengthChanged();
    void patternLpbChanged();
    void notesChanged();

public slots:

private:
    float m_length; // pattern length in beats
    int m_lpb; // grid subdevisions per beat
    QList<Note*> m_notes;
    QList<Note*> m_notes_old;
    static void append_note(QQmlListProperty<Note> *notes, Note *note);
    void stash_notes();
};

Q_DECLARE_METATYPE(QQmlListProperty<Note>)
#endif // PATTERN_H
