TEMPLATE = app

QT += core gui widgets quick
CONFIG += c++11 console

SOURCES += main.cpp \
    oscpack/ip/IpEndpointName.cpp \
    oscpack/osc/OscOutboundPacketStream.cpp \
    oscpack/osc/OscPrintReceivedElements.cpp \
    oscpack/osc/OscReceivedElements.cpp \
    oscpack/osc/OscTypes.cpp \
    OscClient.cpp \
    OscServer.cpp \
    note.cpp \
    pattern.cpp

win32 {
    SOURCES += oscpack/ip/win32/NetworkingUtils.cpp \
    oscpack/ip/win32/UdpSocket.cpp
    LIBS += -lws2_32 -lwinmm
}

!win32 {
    SOURCES += oscpack/ip/posix/NetworkingUtils.cpp \
    oscpack/ip/posix/UdpSocket.cpp
}


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
    OscClient.h \
    OscServer.h \
    note.h \
    pattern.h

DISTFILES += \
    global.js

OTHER_FILES = content/images/*
