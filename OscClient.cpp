#include "OscClient.h"

OscClient::OscClient(QObject *parent, std::string server, int port ) : QObject(parent)
{
    this->isConnected = false;
    this->server = server;
    this->port = port;
}

void OscClient::connect()
{


    static osc::UdpTransmitSocket transmitSocket( osc::IpEndpointName( this->server.c_str(), this->port ) );
    this->transmitSocket = &transmitSocket;

    static osc::OutboundPacketStream stream( this->buffer, OUTPUT_BUFFER_SIZE );
    this->stream = &stream;

    this->isConnected = true;

}

void OscClient::sendMsg(const QString msg)
{

    if ( !this->isConnected ) {
        qDebug("oscclient: not connected! connecting now ...");
        this->connect();
    }

    qDebug("oscclient: sending message:");
    qDebug(msg.toLatin1().data());

    (*this->stream) << osc::BeginBundleImmediate
        << osc::BeginMessage( msg.toStdString().c_str() )
        << osc::EndMessage << osc::EndBundle;

    qDebug("transmit data size: %d", (int) this->stream->Size());
    qDebug(this->stream->Data());

    this->transmitSocket->Send( this->stream->Data(), this->stream->Size() );
    this->stream->Clear();

}
