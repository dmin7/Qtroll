#ifndef OSCLISTENER_H
#define OSCLISTENER_H

#include <iostream>
#include <cstring>
#include <cstdlib>

#include "oscpack/osc/OscReceivedElements.h"
#include "oscpack/osc/OscPacketListener.h"
#include "oscpack/ip/UdpSocket.h"


#include "oscpack/osc/OscPrintReceivedElements.h"
#include "oscpack/ip/PacketListener.h"

class OscListener : public PacketListener{
public:
    virtual void ProcessPacket( const char *data, int size,
            const IpEndpointName& remoteEndpoint )
    {
        (void) remoteEndpoint; // suppress unused parameter warning

        std::cout << osc::ReceivedPacket( data, size );
    }
};

#endif
