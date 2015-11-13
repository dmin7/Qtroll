#include "udpserver.h"
#include "osclistener.h"

#include <thread>

UDPServer::UDPServer(QObject *parent) : QObject(parent)
{
    this->isStarted = false;
}

void run(UdpListeningReceiveSocket *s)
{
    s->Run();
}

void UDPServer::start()
{

    static OscListener listener;
    static UdpListeningReceiveSocket socket(
                IpEndpointName( IpEndpointName::ANY_ADDRESS, CLIENT_PORT ),
                &listener );
    //this->recieveSocket = &socket;
    this->isStarted = true;

    socket.Run();

    //std::thread run_t(run, &socket);
    //run_t.join();
}


/*
#include "udpserver.h"
#include <thread>

UDPServer::UDPServer(QObject *parent) : QObject(parent), osc::OscPacketListener()
{
    this->isStarted = false;
}

void UDPServer::ProcessMessage(
                const osc::ReceivedMessage& m,
                const IpEndpointName& remoteEndpoint )
{
    (void) remoteEndpoint; // suppress unused parameter warning

    qDebug("oscserver: got message!");

    try {
        if ( std::strcmp( m.AddressPattern(), "/qtroll/transport/start" ) == 0 )
        {
            qDebug("oscserver: recieved transport start!");

        }
        else if (std::strcmp( m.AddressPattern(), "/qtroll/notes" ) == 0 )
        {
            osc::ReceivedMessageArgumentStream args = m.ArgumentStream();

        };
    } catch( osc::Exception& e )
    {
        qDebug("oscserver: Exception: %s", e.what());
    };
};


void run(UdpListeningReceiveSocket *s)
{
    s->Run();
}

void UDPServer::start()
{

    static UdpListeningReceiveSocket socket(
                IpEndpointName( "localhost", CLIENT_PORT ),
                this );
    this->recieveSocket = &socket;
    this->isStarted = true;
    std::thread run_t(run, &socket);
    run_t.join();
}
  */
