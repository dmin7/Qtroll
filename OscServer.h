#ifndef OscServer_H
#define OscServer_H

#include <QObject>
#include <thread>

#include "oscpack/osc/OscReceivedElements.h"
#include "oscpack/osc/OscPacketListener.h"
#include "oscpack/osc/OscTypes.h"
#include "oscpack/ip/UdpSocket.h"
#include "oscpack/ip/IpEndpointName.h"

//#define CLIENT_PORT 7000

class OscServer : public QObject, public osc::OscPacketListener
{
    Q_OBJECT
public:
    OscServer(QObject *parent = 0);
    OscServer(QObject *parent, const OscServer & mom);
    OscServer & operator=(const OscServer & mom);

    Q_INVOKABLE void start();

    /// listen_port is the port to listen for messages on
    Q_INVOKABLE void setup( int listen_port );



protected:
    /// process an incoming osc message and add it to the queue
    void ProcessMessage( const osc::ReceivedMessage &m, const osc::IpEndpointName& remoteEndpoint );

signals:
    void clear();
    void receiveNote(int val, float time, float len);

public slots:

private:
    void setup(osc::UdpListeningReceiveSocket * socket);
    //osc::UdpListeningReceiveSocket *recieveSocket;
    QList<QObject*> *noteData;
    // shutdown the listener
    void shutdown();
    // socket to listen on
    std::unique_ptr<osc::UdpListeningReceiveSocket, std::function<void(osc::UdpListeningReceiveSocket*)>> listen_socket;

    std::thread listen_thread;
    int listen_port;
    bool allowReuse;

    bool isStarted;
};

#endif // OscServer_H
