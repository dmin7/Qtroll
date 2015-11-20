#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "piano.h"
#include "OscClient.h"
#include "OscServer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    OscClient udp_client;
    qmlRegisterType<OscClient>("OscClient", 1, 0, "OscClient");

    OscServer udp_server;
    qmlRegisterType<OscServer>("OscServer", 1, 0, "OscServer");


    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    Piano p;
    p.show();

    return app.exec();
}

