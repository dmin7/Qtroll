#include "OscServer.h"

#include <thread>

OscServer::OscServer(QObject *parent)
    : QObject(parent)
    ,allowReuse(true)
    ,listen_port(0)
{
    this->isStarted = false;
}

OscServer::OscServer(QObject *parent, const OscServer & mom)
    : QObject(parent)
    ,allowReuse(mom.allowReuse)
    ,listen_port(mom.listen_port){
        if (mom.listen_port){
            setup(listen_port);
        }
        this->isStarted = false;
}


OscServer & OscServer::operator=(const OscServer & mom){
    if(this == &mom) return *this;

    //allowReuse = mom.allowReuse;
    listen_port = mom.listen_port;
    if(mom.listen_socket){
        setup(listen_port);
    }
    return *this;
}

void OscServer::setup( int listen_port )
{
    /*
    if( UdpSocket::GetUdpBufferSize() == 0 ){
        UdpSocket::SetUdpBufferSize(65535);
    }
    */
    // if we're already running, shutdown before running again
    if ( listen_socket ){
        shutdown();
    }

    // create socket
    auto socket = new osc::UdpListeningReceiveSocket( osc::IpEndpointName( osc::IpEndpointName::ANY_ADDRESS, listen_port ), this);
    auto deleter = [](osc::UdpListeningReceiveSocket*socket){
        // tell the socket to shutdown
        socket->Break();
        delete socket;
    };
    auto new_ptr = std::unique_ptr<osc::UdpListeningReceiveSocket, decltype(deleter)>(socket, deleter);
    listen_socket = std::move(new_ptr);

    listen_thread = std::thread([this]{
        listen_socket->Run();
    });

    // detach thread so we don't have to wait on it before creating a new socket
    // or on destruction, the custom deleter for the socket unique_ptr already
    // does the right thing
    listen_thread.detach();

    this->listen_port = listen_port;
}

void OscServer::start()
{

    this->setup(7001);
    this->isStarted = true;
}

void OscServer::shutdown()
{
    listen_socket.reset();
}

void OscServer::ProcessMessage( const osc::ReceivedMessage &m, const osc::IpEndpointName& remoteEndpoint )
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

        } else
        {
            qDebug(m.AddressPattern());
        }
            ;
    } catch( osc::Exception& e )
    {
        qDebug("oscserver: Exception: %s", e.what());
    };
}

