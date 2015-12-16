#ifndef NOTE_H
#define NOTE_H

#include <QObject>

class Note : public QObject
{
    Q_OBJECT
    /* external properties (from renoise) */
    Q_PROPERTY(int noteValue READ noteValue WRITE setNoteValue NOTIFY noteValueChanged)
    Q_PROPERTY(float noteTime READ noteTime WRITE setNoteTime NOTIFY noteTimeChanged)
    Q_PROPERTY(float noteLength READ noteLength WRITE setNoteLength NOTIFY noteLengthChanged)
    Q_PROPERTY(int noteVolume READ noteVolume WRITE setNoteVolume NOTIFY noteVolumeChanged)
    Q_PROPERTY(int noteInstrument READ noteInstrument WRITE setNoteInstrument NOTIFY noteInstrumentChanged)
    Q_PROPERTY(int noteLine READ noteLine WRITE setNoteLine NOTIFY noteLineChanged)
    Q_PROPERTY(int noteColumn READ noteColumn WRITE setNoteColumn NOTIFY noteColumnChanged)
    /* internal properties */
    Q_PROPERTY(bool noteIsSelected READ noteIsSelected WRITE setNoteIsSelected NOTIFY noteIsSelectedChanged)
    Q_PROPERTY(bool noteDeleted READ noteDeleted WRITE setNoteDeleted NOTIFY noteDeletedChanged)

public:
    /* constructor */
    explicit Note(QObject *parent = 0);

    /* getters and setters */
    int noteValue() const;
    void setNoteValue(int value);
    float noteTime() const;
    void setNoteTime(float time);
    float noteLength() const;
    void setNoteLength(float length);
    int noteVolume() const;
    void setNoteVolume(int vol);
    int noteInstrument() const;
    void setNoteInstrument(int instr);
    int noteLine() const;
    void setNoteLine(int line);
    int noteColumn() const;
    void setNoteColumn(int col);

    bool noteIsSelected() const;
    void setNoteIsSelected(bool sel);
    bool noteDeleted() const;
    void setNoteDeleted(bool del);

signals:
    void noteValueChanged();
    void noteTimeChanged();
    void noteLengthChanged();
    void noteVolumeChanged();
    void noteInstrumentChanged();
    void noteLineChanged();
    void noteColumnChanged();

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
    int m_volume;
    int m_line;
    int m_column;
    bool m_is_selected;
    bool m_deleted;

};

#endif // NOTE_H
