#include "systray.h"



void SysTray::startTray()
{
    Display *display = XOpenDisplay(0);
    Window root = DefaultRootWindow(display);
    bool block = true;

//    net_system_tray_opcode = XInternAtom(display, "_NET_SYSTEM_TRAY_OPCODE", False);
//    net_system_tray_message_data = XInternAtom(display, "_NET_SYSTEM_TRAY_MESSAGE_DATA", False);
//    xembed = XInternAtom(display, "_XEMBED", False);
//    xembed_info = XInternAtom(display, "_XEMBED_INFO", False);

    QString s = QString("_NET_SYSTEM_TRAY_S%1").arg(DefaultScreen(display));
    Atom _NET_SYSTEM_TRAY_S =  XInternAtom(display, s.toLatin1(), False);

    if (XGetSelectionOwner(display, _NET_SYSTEM_TRAY_S) != None)
    {
        block = false;
        //qWarning() << "Another systray is running";
    }

    // init systray protocol
    trayId = XCreateSimpleWindow(display, root, -1, -1, 1, 1, 0, 0, 0);

    XSetSelectionOwner(display, _NET_SYSTEM_TRAY_S, trayId, CurrentTime);
    if (XGetSelectionOwner(display, _NET_SYSTEM_TRAY_S) != trayId)
    {
        block = false;
        qWarning() << "Can't get systray manager";
    }

    if (block)
    {
        int orientation = _NET_SYSTEM_TRAY_ORIENTATION_HORZ;
        Atom _orientation = XInternAtom(display, "_NET_SYSTEM_TRAY_ORIENTATION", False);

        XChangeProperty(display, trayId, _orientation, XA_CARDINAL, 32, PropModeReplace, (unsigned char *) &orientation, 1);

        // ** Visual ********************************
        VisualID visualId = 0;
        Atom visual = XInternAtom(display, "_NET_SYSTEM_TRAY_VISUAL", False);
        XChangeProperty(display, trayId, visual, XA_VISUALID, 32, PropModeReplace, (unsigned char*)&visualId, 1);
//        if (visualId)
//        {
//            XChangeProperty(display, trayId, visual, XA_VISUALID, 32, PropModeReplace, (unsigned char*)&visualId, 1);
//        }
        // ******************************************

        XClientMessageEvent ev;
        Atom manager = XInternAtom(display, "MANAGER", False);

        damageEvent = 0;
        damageError = 0;

        ev.type = ClientMessage;
        ev.window = root;
        ev.message_type = manager;
        ev.format = 32;
        ev.data.l[0] = CurrentTime;
        ev.data.l[1] = _NET_SYSTEM_TRAY_S;
        ev.data.l[2] = trayId;
        ev.data.l[3] = 0;
        ev.data.l[4] = 0;

        XSendEvent(display, root, False, StructureNotifyMask, (XEvent*)&ev);
        //qDebug() << "Systray started";
    }

    XCloseDisplay(display);
}
