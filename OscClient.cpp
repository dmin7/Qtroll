#include "OscClient.h"
#include <QDebug>

OscClient::OscClient(QObject *parent) : QObject(parent)
{
    this->isConnected = false;
}



void OscClient::connect(const QString &server, const int port)
{

    this->socket.SetAllowReuse(true);
    this->socket.Connect(osc::IpEndpointName( server.toStdString().c_str(), (int) port ) );


    this->port = port;
    this->server = server.toStdString();
    //this->transmitSocket = &transmitSocket;

    //static osc::OutboundPacketStream stream( this->buffer, OUTPUT_BUFFER_SIZE );
    //this->stream = &stream;

    this->isConnected = true;
    qDebug() << "OSC client connected to: " << this->server.c_str() << "\nPort: " << this->port;


}

void OscClient::sendMsg(const QString msg)
{

    if ( !this->isConnected ) {
        qDebug("oscclient: not connected! connecting now ...");
        //this->connect(new QString(this->server), this->port);
    }
    static const int OUTPUT_BUFFER_SIZE = 327680;
    char buffer[OUTPUT_BUFFER_SIZE];
    osc::OutboundPacketStream stream(buffer, OUTPUT_BUFFER_SIZE );

    qDebug("oscclient: sending message:");
    qDebug(msg.toLatin1().data());

    (stream) << osc::BeginBundleImmediate
        << osc::BeginMessage( msg.toStdString().c_str() )
        << osc::EndMessage << osc::EndBundle;

    qDebug("transmit data size: %d", (int) stream.Size());
    qDebug(stream.Data());

    this->socket.Send( stream.Data(), stream.Size() );
    stream.Clear();

}

void OscClient::triggerNote(int note, bool note_on)
{
    static const int OUTPUT_BUFFER_SIZE = 327680;
    char buffer[OUTPUT_BUFFER_SIZE];
    osc::OutboundPacketStream stream(buffer, OUTPUT_BUFFER_SIZE );

    stream << osc::BeginBundleImmediate
        << osc::BeginMessage( note_on? "/renoise/trigger/note_on" : "/renoise/trigger/note_off"  )
        << -1 << -1 << note;
    if (note_on) {
           stream << 120;
    }
    stream << osc::EndMessage << osc::EndBundle;

    this->socket.Send( stream.Data(), stream.Size() );
    stream.Clear();
}

void OscClient::sendNote(Note *note)
{
    static const int OUTPUT_BUFFER_SIZE = 327680;
    char buffer[OUTPUT_BUFFER_SIZE];
    osc::OutboundPacketStream stream(buffer, OUTPUT_BUFFER_SIZE );

    stream << osc::BeginBundleImmediate
        << osc::BeginMessage( "/renoise/qtroll/note" )
        << note->actionCode()
        << note->noteValue()
        << note->noteTime()
        << note->noteLength()
        << note->noteVolume()
        << note->noteInstrument()
        << note->noteLine()
        << note->noteColumn()
        << osc::EndMessage << osc::EndBundle;

    this->socket.Send( stream.Data(), stream.Size() );
    stream.Clear();
}


