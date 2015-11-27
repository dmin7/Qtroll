Qt-Pianoroll für Renoise
Motivation
Renoise

Renoise ist eine plattformunabhängige DAW (Digital Audio Workstation), die auf dem Prinzip des Trackers aufbaut. Ein Tracker ist ein Musikprogramm bei dem die Noteneingabe und Editierung in Tabellenform und vorwiegend mit der Tastatur erfolgt (In Abgrenzung zur Eingabe mit der Maus, oder über externe Midigeräte).



Quelle und Funktionsübersicht

Die meisten kommerziellen DAWs verwenden zur Eingabe und Editierung ein Pianoroll-Interface. Folgende Abbildung zeigt den Pianoroll von Fruity Loops.



Quelle und Funktionsbeschreibung

Beides hat Vor- und Nachteile, das Trackerinterface eignet sichfür eine schnelle, tastatur-gestützte Eingabe, das Pianoroll-Interface ist im allgemeinen besser geeignet um "live" eingespielte Notendaten zu editieren.

Renoise ist in Lua scriptbar, und stellt OSC-Server und Client-Funktionen zur Verfügung, womit es möglich wird ein externes Pianoroll-Interface für Renoise zu schreiben. Die Projektidee ist: die Notendaten eines einzelnen Patterns/Tracks werden über OSC an eine externe Qt-Anwendung verschickt, in der sie dargestellt und bearbeitet werden können. Änderungen werden wiederum über OSC an Renoise zurückgeschickt. Die Qt-Anwendung soll beim Wechseln eines Patterns/Tracks automatisch upgedated werden.
Features:

- Datenmodell: Notendaten 
- Repräsentation des Datenmodells in Pianoroll-Form
- Pianoroll:
    - Noten hinzufügen (einfacher Klick)
    - Noten verschieben
    - Notenlänge ändern
    - Noten löschen
    - mehrere Noten selektieren (inkl. oben genannte Operationen)

- Synchronisierung des Datenmodells mit Renoise via OSC

Optionale Features:

    erweiterte Editierfunktionen (z.B Quantisierung)
    Event-Editor (siehe unteres Teilfenster im FruityLoops Pianoroll)
    Standalone-Operation ohne Renoise (Midi, OSC, intern?)
    Programmsteuerungsfunktionen für Renoise (Start, Stop, ...) ...

Milestones:

1. Milestone (27.11):
    OSC/Renoise:
        OSC-Sender und Reciever
        Renoise-Tool mit OSC-Client + Server

    Datenmodell und Qml-Integration:
        Entwurf
        Qml-Integration des Datenmodells

    Gui (Qml):
        Design-Entwurf
        Implementierung der statischen Oberfläche

2. Milestone (18.12):

    OSC/Renoise:
        Kommunikation mit Datenmodell (Empfangene Daten -> Modell, Modell -> Senden der Daten via OSC)


    Gui (Qml):
        Implementierung der dynamischen Oberfläche (Rendern Notendaten)
        Implementieren der Editierfunktionen auf dem Datenmodell


3. Milestone (22.1)
    Integration Einzelkomponenten
    (Unit-)Tests
    Abschließen der Dokumentation
