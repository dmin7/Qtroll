#ifndef NOTE_H
#define NOTE_H

#include <QObject>

class Note : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int noteValue READ noteValue WRITE setNoteValue NOTIFY noteValueChanged)
    Q_PROPERTY(float noteTime READ noteTime WRITE setNoteTime NOTIFY noteTimeChanged)
    Q_PROPERTY(float noteLength READ noteLength WRITE setNoteLength NOTIFY noteLengthChanged)
    Q_PROPERTY(bool noteIsSelected READ noteIsSelected WRITE setNoteIsSelected NOTIFY noteIsSelectedChanged)
    Q_PROPERTY(bool noteDeleted READ noteDeleted WRITE setNoteDeleted NOTIFY noteDeletedChanged)
public:
    explicit Note(QObject *parent = 0);

    //explicit Note(QObject *parent = 0, int value = 0, float time = 0, float length = 0.1, int instr = 0, int track = 0, int pattern = 0);
    int noteValue() const;
    void setNoteValue(int value);
    float noteTime() const;
    void setNoteTime(float time);
    float noteLength() const;
    void setNoteLength(float length);
    bool noteIsSelected() const;
    void setNoteIsSelected(bool sel);
    bool noteDeleted() const;
    void setNoteDeleted(bool del);

signals:
    void noteValueChanged();
    void noteTimeChanged();
    void noteLengthChanged();
    void noteIsSelectedChanged();
    void noteDeletedChanged();

public slots:

private:
    int m_value;
    float m_time;
    float m_length;
    int m_instr;
    int m_track;
    int m_pattern;
    bool m_is_selected;
    bool m_deleted;

};

#endif // NOTE_H
