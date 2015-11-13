TEMPLATE = app

QT += qml quick widgets
CONFIG += c++11

SOURCES += main.cpp \
    oscpack/ip/IpEndpointName.cpp \
    oscpack/ip/NetworkingUtils.cpp \
    oscpack/ip/UdpSocket.cpp \
    oscpack/osc/OscOutboundPacketStream.cpp \
    oscpack/osc/OscPrintReceivedElements.cpp \
    oscpack/osc/OscReceivedElements.cpp \
    oscpack/osc/OscTypes.cpp \
    udpclient.cpp \
    udpserver.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    oscpack/ip/IpEndpointName.h \
    oscpack/ip/NetworkingUtils.h \
    oscpack/ip/PacketListener.h \
    oscpack/ip/TimerListener.h \
    oscpack/ip/UdpSocket.h \
    oscpack/osc/MessageMappingOscPacketListener.h \
    oscpack/osc/OscException.h \
    oscpack/osc/OscHostEndianness.h \
    oscpack/osc/OscOutboundPacketStream.h \
    oscpack/osc/OscPacketListener.h \
    oscpack/osc/OscPrintReceivedElements.h \
    oscpack/osc/OscReceivedElements.h \
    oscpack/osc/OscTypes.h \
    udpclient.h \
    udpserver.h \
    osclistener.h

