#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

#include "udpclient.h"
#include "udpserver.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    UDPClient udp_client;
    qmlRegisterType<UDPClient>("UDPClient", 1, 0, "UDPClient");

    UDPServer udp_server;
    qmlRegisterType<UDPServer>("UDPServer", 1, 0, "UDPServer");

    /*
    UdpListeningReceiveSocket socket(
                    IpEndpointName( "127.0.0.2", CLIENT_PORT ),
                    &udp_server );
    socket.Run();
    */

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

