#ifndef OscClient_H
#define OscClient_H

#include <QObject>
#include <QQmlListProperty>
#include <QDebug>

#include "oscpack/osc/OscOutboundPacketStream.h"
#include "oscpack/ip/UdpSocket.h"

#include "note.h"


#define SERVER_IP   "192.168.3.30"
#define SERVER_PORT 8000

//#define OUTPUT_BUFFER_SIZE 1024

class OscClient : public QObject
{
    Q_OBJECT
public:
    explicit OscClient(QObject *parent = 0);
    Q_INVOKABLE void connect(const QString &server, const int port);
    Q_INVOKABLE void sendMsg(const QString msg);
    Q_INVOKABLE void triggerNote(int note, bool note_on = true);
    Q_INVOKABLE void sendNote(Note *note);

signals:
    void test();

public slots:

private:
    std::string server;
    int port;
    bool isConnected;
    osc::UdpTransmitSocket socket = osc::UdpTransmitSocket( osc::IpEndpointName( "127.0.0.1", 8000 ));
    //char buffer[OUTPUT_BUFFER_SIZE];
    //QSharedPointer<osc::OutboundPacketStream> stream;

};

#endif // OscClient_H
