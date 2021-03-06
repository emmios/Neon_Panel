#include "threads.h"

struct tray_list {
    QString wclass;
    Window id;
};

void Threads::run()
{

    Display* d = XOpenDisplay(0);
    XSelectInput(d, DefaultRootWindow(d), SubstructureNotifyMask | SubstructureNotifyMask);

    SysTray tray;
    tray.startTray();

    tray_list _tray;
    QList<tray_list> trayList;

    QString arrayDestroy = "";
    QString arrayCreate = "";
    int activated = 0;

    XEvent e;
    XDamageNotifyEvent *dEvent;

    //this->msleep(200);
    unsigned long _items;
    Window *_list = ctx->xwindows(&_items);

    SignalOver *signal = new SignalOver;
    this->main->connect(signal, SIGNAL(onActiveWindow()), this->main, SLOT(activeWindow()));
    this->main->connect(signal, SIGNAL(onRemoveAllWindows()), this->main, SLOT(removeAllWindows()));
    this->main->connect(signal, SIGNAL(onCreate(QString)), this->main, SIGNAL(getCreateWindow(QString)));
    this->main->connect(signal, SIGNAL(onAddWindow(QString)), this->main, SIGNAL(getAddWindow(QString)));
    this->main->connect(signal, SIGNAL(onRemoveTryIcon(int)), this->main, SIGNAL(getRemoveTryIcon(int)));
    this->main->connect(signal, SIGNAL(onNotifications(int)), this->main, SIGNAL(getNotifications(int)));
    this->main->connect(signal, SIGNAL(onAddTryIcon(QString)), this->main, SIGNAL(tryIcon(QString)));

    for (int i = 0; i < _items; i++)
    {
        QString type = QString(ctx->xwindowType(_list[i]));
        if (type == "_NET_WM_WINDOW_TYPE_NORMAL" || type == "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE")
        {
            int status;
            unsigned long nitems;
            QString name = ctx->xwindowName(_list[i]);
            QString wclass = QString(ctx->xwindowClass(_list[i])).toLower();

            if (wclass != "unknow")
            {
                if (wclass != "Synth-Panel")
                {
                    arrayCreate += "|@|" + name + "=#=" + wclass + "=#=" + QString::number((int)_list[i])  + "=#=" + QString::number((int)ctx->xwindowPid(_list[i]))  + '=#=' + QString((char *)ctx->windowProperty(d, _list[i], "_OB_APP_CLASS", &nitems, &status));
                    this->msleep(50);
                }
            }
        }
    }

    if (!arrayCreate.isEmpty())
    {
        //QMetaObject::invokeMethod(this->main, "createWindow", Q_ARG(QVariant,  arrayCreate));
        signal->onCreate(arrayCreate);
    }
    else if (arrayCreate.isEmpty())
    {
        //QMetaObject::invokeMethod(this->main, "removeAllWindows");
        signal->onRemoveAllWindows();
    }

    while (true)
    {
        XNextEvent(d, &e);
        dEvent = reinterpret_cast<XDamageNotifyEvent*>(&e);

        //create new windows
        if (e.type == CreateNotify)
        {
            this->msleep(200);
            QString type = QString(ctx->xwindowType(e.xmap.window));
            arrayCreate = "";

            if (type == "_NET_WM_WINDOW_TYPE_NORMAL" || type == "_NET_WM_WINDOW_TYPE_DIALOG" || type == "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE")
            {
                int status;
                unsigned long nitems;

                QString name = ctx->xwindowName(e.xmap.window);
                QString wclass = QString(ctx->xwindowClass(e.xmap.window)).toLower();

                if (wclass != "unknow")
                {
                    if (wclass != "Neon_Panel")
                    {
                        //qDebug() << e.xmap.window << wclass;
                        //arrayCreate += "|@|" + name + "=#=" + wclass + "=#=" + QString::number((int)e.xmap.window)  + "=#=" + QString::number((int)ctx->xwindowPid(e.xmap.window))  + '=#=' + QString((char *)ctx->windowProperty(d, e.xmap.window, "_OB_APP_CLASS", &nitems, &status));
                        //QMetaObject::invokeMethod(this->main, "addWindow", Q_ARG(QVariant,  name + "=#=" + wclass + "=#=" + QString::number((int)e.xmap.window)  + "=#=" + QString::number((int)ctx->xwindowPid(e.xmap.window))  + '=#=' + QString((char *)ctx->windowProperty(d, e.xmap.window, "_OB_APP_CLASS", &nitems, &status))));
                        arrayCreate = name + "=#=" + wclass + "=#=" + QString::number((int)e.xmap.window)  + "=#=" + QString::number((int)ctx->xwindowPid(e.xmap.window))  + '=#=' + QString((char *)ctx->windowProperty(d, e.xmap.window, "_OB_APP_CLASS", &nitems, &status));
                        signal->onAddWindow(arrayCreate);
                        //QMetaObject::invokeMethod(this->main, "addWindow", Q_ARG(QVariant, arrayCreate));
                    }
                }
            }
        }
        else if (e.type == DestroyNotify)
        {
            this->msleep(200);
            unsigned long items;
            Window *list = ctx->xwindows(&items);
            arrayDestroy = "";

            for (int i = 0; i < items; i++)
            {
                QString type = QString(ctx->xwindowType(list[i]));
                if (type == "_NET_WM_WINDOW_TYPE_NORMAL" || type == "_NET_WM_WINDOW_TYPE_DIALOG" || type == "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE")
                {
                    int status;
                    unsigned long nitems;
                    //qDebug() << "list destroy" << list[i];
                    QString name = ctx->xwindowName(list[i]);
                    QString wclass = QString(ctx->xwindowClass(list[i])).toLower();
                    //arrayDestroy += ";" + QString::number((int)list[i]);
                    arrayDestroy += "|@|" + name + "=#=" + wclass + "=#=" + QString::number((int)list[i])  + "=#=" + QString::number((int)ctx->xwindowPid(list[i]))  + '=#=' + QString((char *)ctx->windowProperty(d, list[i], "_OB_APP_CLASS", &nitems, &status));
                    //this->msleep(50);
                }
            }

            if (!arrayDestroy.isEmpty())
            {
                //QMetaObject::invokeMethod(this->main, "createWindow", Q_ARG(QVariant, arrayDestroy));
                signal->onCreate(arrayDestroy);
            }
            else if (arrayDestroy.isEmpty())
            {
                signal->onRemoveAllWindows();
            }

            for (int i = 0; i < trayList.length(); i++)
            {
                //if (ctx->xwindowTrayIcon(trayList[i].id).isNull())
                if (ctx->xwindowIcon(trayList[i].id, QSize(48, 48)).isNull())
                {
                    //QMetaObject::invokeMethod(this->main, "removeTryIcon", Q_ARG(QVariant, (int)trayList[i].id));
                    signal->onRemoveTryIcon((int)trayList[i].id);
                    trayList.removeAt(i);
                }
            }
        }
        else if (e.type == UnmapNotify || e.type == ClientMessage)
        {
            //this->msleep(100);
            // tray notify
            // unknow 140415365808128 17 17 17 Telegram unknow
            bool add = false;

            Window id = e.xmap.window;
            QString wclass = ctx->xwindowClass(e.xmap.window);

            if (wclass == "unknow")
            {
                id = e.xclient.data.l[2];
                wclass = QString(ctx->xwindowClass(e.xclient.data.l[2]));
            }

            if (wclass == "unknow")
            {
                id = dEvent->drawable;
                wclass = ctx->xwindowClass(dEvent->drawable);
            }

            for (int i = 0; i < trayList.length(); i++)
            {
                if (trayList[i].wclass == wclass)
                {
                    add = true;
                    break;
                }

                if (trayList[i].id == id)
                {
                    add = true;
                    break;
                }
            }

            if (add)
            {
                //QMetaObject::invokeMethod(this->main, "notifications", Q_ARG(QVariant,  (int)id));
                signal->onNotifications((int)id);
            }
        }

        else if (e.type == ConfigureNotify)
        {
            int atual = (int)e.xconfigure.window;
            //qDebug() << e.xconfigure.window;
            if (activated != atual)
            {
                activated = atual;
                signal->onActiveWindow();
                //this->msleep(50);
            }
        }

        //XDamageNotify
        //qDebug() << e.type << ctx->xwindowClass(dEvent->drawable) << e.xclient.data.l[1] << dEvent->type + XDamageNotify << dEvent->type << ctx->xwindowClass(e.xclient.data.l[2]) << ctx->xwindowClass(e.xmap.window);
        // create icon systray
        else if (e.xclient.data.l[1] == SYSTEM_TRAY_REQUEST_DOCK || e.xclient.data.l[1] > 1)
        {
            Window id = e.xclient.data.l[2];
            QString wclass = QString(ctx->xwindowClass(id));
            bool add = true;

//            if (wclass == "unknow")
//            {
//                id = dEvent->drawable;
//                wclass = ctx->xwindowClass(dEvent->drawable);
//            }

            if (wclass == "Neon_Panel")
            {
                add = false;
            }

            if (wclass == "Synth-Panel")
            {
                add = false;
            }

            if (wclass != "unknow")
            {
                //this->msleep(50);

                QString type = QString(ctx->xwindowType(id));

                if (type == "_NET_WM_WINDOW_TYPE_NORMAL" || type == "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE")
                {
                    // continue
                } else {
                    add = false;
                }

                if (ctx->xwindowIcon(id, QSize(48, 48)).isNull())
                {
                    add = false;
                }

                for (int i = 0; i < trayList.length(); i++)
                {
                    if (trayList[i].wclass == wclass)
                    {
                        add = false;
                        break;
                    }

                    if (trayList[i].id == id)
                    {
                        add = false;
                        break;
                    }
                }

                if (add)
                {
                    //QString args = QString(ctx->xwindowName(id)) + ";" + QString::number(id) + ";" + wclass + ";" + QString((char *)ctx->windowProperty(d, id, "_OB_APP_CLASS", &nitems, &status));
                    QString args = QString(ctx->xwindowName(id)) + "|@|" + QString::number(id) + "|@|" + wclass + "|@|" + QString::number(ctx->xwindowPid(id));
                    //QMetaObject::invokeMethod(this->main, "addTryIcon", Q_ARG(QVariant,  args));
                    signal->onAddTryIcon(args);

                    _tray.wclass = wclass;
                    _tray.id = id;
                    trayList.append(_tray);
                }
            }
        }
    }

    //XFree(d);
    //XFlush(d);
    XCloseDisplay(d);
}
