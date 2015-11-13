#ifndef UDPSERVER_H
#define UDPSERVER_H

#include <QObject>
#include <thread>

#include "oscpack/osc/OscReceivedElements.h"
#include "oscpack/osc/OscPacketListener.h"
#include "oscpack/ip/UdpSocket.h"

#define CLIENT_PORT 7000

class UDPServer : public QObject
{
    Q_OBJECT
public:
    explicit UDPServer(QObject *parent = 0);
    Q_INVOKABLE void start();

signals:

public slots:

private:
    UdpListeningReceiveSocket *recieveSocket;
    bool isStarted;
};

#endif // UDPSERVER_H
