#ifndef SYSTRAY_H
#define SYSTRAY_H

#include <QObject>
#include <QX11Info>
#include <QList>


#include "xlibutil.h"


#define _NET_SYSTEM_TRAY_ORIENTATION_HORZ 0
#define _NET_SYSTEM_TRAY_ORIENTATION_VERT 1

#define SYSTEM_TRAY_REQUEST_DOCK    0
#define SYSTEM_TRAY_BEGIN_MESSAGE   1
#define SYSTEM_TRAY_CANCEL_MESSAGE  2

#define XEMBED_EMBEDDED_NOTIFY  0
#define XEMBED_MAPPED (1 << 0)


class SysTray : public QObject
{

private:
    int damageEvent;
    int damageError;
    Window trayId;
    void clientMessageEvent(XClientMessageEvent* e);
    Atom net_system_tray_opcode;
    Atom net_system_tray_message_data;
    Atom xembed_info;
    Atom xembed;

public:
    void startTray();
    void stopTray();
};

#endif // SYSTRAY_H
