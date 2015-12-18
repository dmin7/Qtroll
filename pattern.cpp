#include "pattern.h"
#include "QDebug"

Pattern::Pattern(QObject *parent) : QObject(parent)
{

}

void Pattern::clear()
{
    m_notes.clear();
}

int Pattern::count()
{
    //qDebug() << "number of notes: " << m_notes.count();
    return m_notes.count();
}

void Pattern::add_note(int val, float time, float len){
    stash_notes();
    Note *note = new Note();
    note->setNoteValue(val);
    note->setNoteLength(len);
    note->setNoteTime(time);
    m_notes.append(note);
}

void Pattern::delete_note(int index){
    stash_notes();
    //m_notes.removeAt(index);
    m_notes[index]->setNoteLength(0);
    m_notes[index]->setNoteTime(0);
    m_notes[index]->setNoteValue(0);
    m_notes[index]->setNoteDeleted(true);
    qDebug() << "removed Note: " << m_notes[index]->noteValue();
}

void Pattern::stash_notes(){
    m_notes_old = m_notes;
}

void Pattern::undo_change(){
    if(!m_notes_old.isEmpty()){
        m_notes = m_notes_old;
    }
}

float Pattern::patternLength() {
    return this->m_length;
}

int Pattern::patternLpb() {
    return this->m_lpb;
}

void Pattern::setPatternLength(float length) {
    if (!(this->m_length == length)) {
        this->m_length = length;
    }
}

void Pattern::setPatternLpb(int lpb) {
    if (!(this->m_lpb == lpb)) {
        this->m_lpb = lpb;
    }
}

QQmlListProperty<Note> Pattern::notes()
{
    return QQmlListProperty<Note>(this, m_notes);
}

Note *Pattern::note(int index) const
{
    return m_notes.at(index);
}

void Pattern::append_note(QQmlListProperty<Note> *notes, Note *note)
{
    Pattern *pattern = qobject_cast<Pattern*>(notes->object);
    if (pattern) {
        //note->setParent(pattern);
        pattern->m_notes.append(note);
    }
}
