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

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

