#include "note.h"

Note::Note(QObject *parent) : QObject(parent)
{

}

Note::Note(QObject *parent, int value, float time, float length, int instr, int track, int pattern)
{
    this->m_value = value;
    this->m_time = time;
    this->m_length = length;
    this->m_instr = instr;
    this->m_track = track;
    this->m_pattern = pattern;
    this->m_is_selected = false;
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

