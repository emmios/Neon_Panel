#include "systhread.h"


void SysThread::run()
{
    Display *d = XOpenDisplay(0);
    SysTray tray;
    QList<QString> trayList;
    QList<Window> _trayList;
    XDamageNotifyEvent *dEvent;

    // tray start
    tray.startTray();

    while (true)
    {
        XEvent e;
        qDebug() << "ok";
        //XNextEvent(d, &e);
        qDebug() << "pass";
        dEvent = reinterpret_cast<XDamageNotifyEvent*>(&e);

        this->sleep(100);

        //XDamageNotify
        //if (e.type == ClientMessage || e.type == CreateNotify)
        qDebug() << e.xclient.data.l[1] << e.type;
        if (e.xclient.data.l[1] > 1 || e.xclient.data.l[1] == SYSTEM_TRAY_REQUEST_DOCK)
        {
            Window id = e.xclient.data.l[2];
            QString wclass = QString(ctx->xwindowClass(id));
            bool add = true;

            if (ctx->xwindowIcon(id).isNull())
            {
                add = false;
            }

            qDebug() << add << wclass << ctx->xwindowClass(dEvent->drawable);
            if (wclass != "unknow")
            {

                for (int i = 0; i < trayList.length(); i++)
                {
                    if (trayList.at(i) == wclass)
                    {
                        add = false;
                        break;
                    }
                }

                for (int i = 0; i < _trayList.length(); i++)
                {
                    if (_trayList.at(i) == id)
                    {
                        add = false;
                        break;
                    }
                }

                QString type = QString(ctx->xwindowType(id));

                if (type == "_NET_WM_WINDOW_TYPE_NORMAL" || type == "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE")
                {
                    if (add)
                    {
                        int status;
                        unsigned long nitems;

                        QString args = QString(ctx->xwindowName(id)) + ";" + QString::number(id) + ";" + wclass + ";" + QString((char *)ctx->windowProperty(d, id, "_OB_APP_CLASS", &nitems, &status)) + ";" + ctx->xwindowLauncher(id);
                        QMetaObject::invokeMethod(this->main, "addTryIcon",
                            Q_ARG(QVariant,  args)
                        );

                        trayList.append(wclass);
                    }
                }
            }
        }
    }

    XFree(d);
    XCloseDisplay(d);
}
