#include "note.h"

Note::Note(QObject *parent) :
    QObject(parent),
    m_value(0),
    m_time(0),
    m_length(0),
    m_instr(0),
    m_track(0),
    m_pattern(0),
    m_is_selected(false),
    m_deleted(false)
{

}

int Note::noteValue() const
{
    return m_value;
}

void Note::setNoteValue(int value)
{
    if (value != m_value) {
        m_value = value;
        emit noteValueChanged();
    }
}

float Note::noteTime() const
{
    return m_time;
}

void Note::setNoteTime(float time)
{
    if (time != m_time) {
        m_time = time;
        emit noteTimeChanged();
    }
}

float Note::noteLength() const
{
    return m_length;
}

void Note::setNoteLength(float length)
{
    if (length != m_length) {
        m_length = length;
        emit noteLengthChanged();
    }
}

int Note::noteVolume() const
{
    return m_volume;
}

void Note::setNoteVolume(int vol)
{
    if (vol != m_volume) {
        m_volume = vol;
        emit noteVolumeChanged();
    }
}

int Note::noteInstrument() const
{
    return m_instr;
}

void Note::setNoteInstrument(int instr)
{
    if (instr != m_instr) {
        m_instr = instr;
        emit noteInstrumentChanged();
    }
}

int Note::noteLine() const
{
    return m_line;
}

void Note::setNoteLine(int line)
{
    if (line != m_line) {
        m_line = line;
        emit noteLineChanged();
    }
}

int Note::noteColumn() const
{
    return m_column;
}

void Note::setNoteColumn(int col)
{
    if (col != m_column) {
        m_column = col;
        emit noteColumnChanged();
    }
}

int Note::actionCode() const
{
    return m_action;
}

void Note::setActionCode(int code)
{
    if (code != m_action) {
        m_action = code;
        emit actionCodeChanged();
    }
}

bool Note::noteIsSelected() const
{
    return m_is_selected;
}

void Note::setNoteIsSelected(bool sel)
{
    if (sel != m_is_selected) {
        m_is_selected = sel;
        emit noteIsSelectedChanged();
    }
}

bool Note::noteDeleted() const
{
    return m_deleted;
}

void Note::setNoteDeleted(bool del)
{
    if(!(del == m_deleted)) {
        m_deleted = del;
        emit noteDeletedChanged();
    }
}

