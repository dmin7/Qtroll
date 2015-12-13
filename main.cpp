#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

//#include "piano.h"
#include "note.h"
#include "pattern.h"
#include "OscClient.h"
#include "OscServer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    /* register qml types */
    qmlRegisterType<OscClient>("OscClient", 1, 0, "OscClient");
    qmlRegisterType<OscServer>("OscServer", 1, 0, "OscServer");
    qmlRegisterType<Pattern>("Pattern", 1, 0, "Pattern");
    qmlRegisterType<Note>("Note", 1, 0, "Note");

    /*
    QList<QObject*> noteData;
    noteData.append(new Note(NULL, 12, 0.0, 0.2));
    noteData.append(new Note(NULL, 15, 0.5, 0.3));
    noteData.append(new Note(NULL, 17, 1, 0.2));
    noteData.append(new Note(NULL, 12, 1.33, 0.7));
    noteData.append(new Note(NULL, 7, 2.33, 0.2));
    noteData.append(new Note(NULL, 8, 3, 0.5));
    */


    QQmlApplicationEngine engine;
    //QQmlContext *ctxt = engine.rootContext();
    //ctxt->setContextProperty("noteData", QVariant::fromValue(noteData));
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

