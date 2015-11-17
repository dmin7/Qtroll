#ifndef OscClient_H
#define OscClient_H

#include <QObject>

#include "oscpack/osc/OscOutboundPacketStream.h"
#include "oscpack/ip/UdpSocket.h"

#define SERVER_IP   "192.168.3.30"
#define SERVER_PORT 8000

#define OUTPUT_BUFFER_SIZE 1024

class OscClient : public QObject
{
    Q_OBJECT
public:
    explicit OscClient(QObject *parent = 0);
    Q_INVOKABLE void connect();
    Q_INVOKABLE void sendMsg(const QString msg);

signals:

public slots:

private:

    bool isConnected;
    osc::UdpTransmitSocket *transmitSocket;
    char buffer[OUTPUT_BUFFER_SIZE];
    osc::OutboundPacketStream *stream;

};

#endif // OscClient_H
