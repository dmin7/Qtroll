#include "udpclient.h"

UDPClient::UDPClient(QObject *parent) : QObject(parent)
{
    this->isConnected = false;
}

void UDPClient::connect()
{

    static UdpTransmitSocket transmitSocket( IpEndpointName( SERVER_IP, SERVER_PORT ) );
    this->transmitSocket = &transmitSocket;

    static osc::OutboundPacketStream stream( this->buffer, OUTPUT_BUFFER_SIZE );
    this->stream = &stream;

    this->isConnected = true;

}

void UDPClient::sendMsg(const QString msg)
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
