#include "xlibutil.h"


Xlibutil::Xlibutil()
{

}

int Xlibutil::numberOfscreens()
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    int num = ScreenCount(d);
    //XFlush(d);
    XCloseDisplay(d);
    return num;
}

void Xlibutil::displayChange(int num)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    Window root = DefaultRootWindow(d);
    XEvent xev;
    Atom wm_state  =  XInternAtom(d, "_NET_CURRENT_DESKTOP", False);

    memset(&xev, 0, sizeof(xev));
    xev.type = ClientMessage;
    xev.xclient.window = root;
    xev.xclient.message_type = wm_state;
    xev.xclient.format = 32;
    xev.xclient.data.l[0] = num;
    xev.xclient.data.l[1] = CurrentTime;

    XSendEvent(d, root, False, SubstructureRedirectMask | SubstructureNotifyMask, &xev);

    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::setMoreDisplay(int num)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    Window root = DefaultRootWindow(d);
    XEvent xev;
    Atom wm_state  =  XInternAtom(d, "_NET_NUMBER_OF_DESKTOPS", False);

    memset(&xev, 0, sizeof(xev));
    xev.type = ClientMessage;
    xev.xclient.window = root;
    xev.xclient.message_type = wm_state;
    xev.xclient.format = 32;
    xev.xclient.data.l[0] = num;
    xev.xclient.data.l[1] = CurrentTime;

    XSendEvent(d, root, False, SubstructureRedirectMask | SubstructureNotifyMask, &xev);

    XFlush(d);
    XCloseDisplay(d);
}

QString Xlibutil::xgetWindowFocused()
{
    Window w;
    int revert_to;
    Display *d = XOpenDisplay(0); //QX11Info::display();
    XGetInputFocus(d, &w, &revert_to);
    XFlush(d);
    XCloseDisplay(d);
    return QString(this->xwindowClass(w));
}

int Xlibutil::xgetWindowFocusedId()
{
    Window w;
    int revert_to;
    Display *d = XOpenDisplay(0); //QX11Info::display();
    XGetInputFocus(d, &w, &revert_to);
    XFlush(d);
    XCloseDisplay(d);
    return (int)this->xwindowPid(w);
}

void Xlibutil::xwindowKill(Window window)
{
    Display *d = XOpenDisplay(0);
    //Atom atom = XInternAtom(d, "_NET_DELETE_WINDOW", False);
    //XSetWMProtocols(d, window, &atom, 1);
    XDestroyWindow(d, window);
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xwindowClose(Window window)
{

    Display *d = XOpenDisplay(0); //QX11Info::display();
    Atom atom = XInternAtom(d, "_NET_CLOSE_WINDOW", False);

    XEvent xev;
    memset(&xev, 0, sizeof(xev));
    xev.type = ClientMessage;
    xev.xclient.window = window;
    xev.xclient.message_type = atom;
    xev.xclient.format = 32;
    xev.xclient.data.l[0] = atom;
    xev.xclient.data.l[1] = CurrentTime;

    XSendEvent(d, DefaultRootWindow(d), False, SubstructureRedirectMask | SubstructureNotifyMask, &xev);
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xreservedSpace(Window window, int h)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();

    // set in xorg reserved space in desktop
    long prop[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    prop[3] = h;

    //"_NET_WM_STRUT"
    XChangeProperty(d, window,
                    XInternAtom(d, "_NET_WM_STRUT", False),
                    XA_CARDINAL, 32, PropModeReplace, (unsigned char *)&prop, 4); //4
    XChangeProperty(d, window,
                    XInternAtom(d, "_NET_WM_STRUT_PARTIAL", False),
                    XA_CARDINAL, 32, PropModeReplace, (unsigned char *)&prop, 12);

    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::openboxChange(Window window, long atom)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    XClientMessageEvent m;
    memset(&m, 0, sizeof(m));
    m.type = ClientMessage;
    m.send_event = True;
    m.display = d;
    m.window = window;
    m.message_type = XInternAtom(d, "_NET_WM_DESKTOP", False);
    m.format = 32;
    m.data.l[0] = atom;
    XSendEvent(d, DefaultRootWindow(d), False, SubstructureRedirectMask | SubstructureNotifyMask, (XEvent *)&m);
    //XSync(display, False);
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xchange(Window window, const char * atom)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();
    Atom tmp = XInternAtom(d, atom, False);
    XChangeProperty(d, window,
                    XInternAtom(d, "_NET_WM_WINDOW_TYPE", False), //_NET_WM_WINDOW_TYPE
                    XA_ATOM, 32, PropModeReplace, (unsigned char *)&tmp, 1); //XA_ATOM
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xchangeProperty(Window window, const char *atom, const char * internalAtom, int format)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();
    Atom tmp = XInternAtom(d, atom, False);
    XChangeProperty(d, window,
                    XInternAtom(d, internalAtom, False), //_NET_WM_WINDOW_TYPE
                    format, 8, 0, (const unsigned char*)atom, QString(atom).length()); //XA_ATOM
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xchangeProperty(Window window, int atom, const char * internalAtom, int format)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();
    //Atom tmp = XInternAtom(display, atom, False);
    XChangeProperty(d, window,
                    XInternAtom(d, internalAtom, False), //_NET_WM_WINDOW_TYPE
                    format, 32, PropModeReplace, (unsigned char*)&atom, 1); //XA_ATOM
    XFlush(d);
    XCloseDisplay(d);
}

char* Xlibutil::xwindowType(Window window)
{
    /*
        (:_NET_WM_WINDOW_TYPE_DESKTOP . :desktop)
        (:_NET_WM_WINDOW_TYPE_DOCK . :dock)
        (:_NET_WM_WINDOW_TYPE_TOOLBAR . :toolbar)
        (:_NET_WM_WINDOW_TYPE_MENU . :menu)
        (:_NET_WM_WINDOW_TYPE_UTILITY . :utility)
        (:_NET_WM_WINDOW_TYPE_SPLASH . :splash)
        (:_NET_WM_WINDOW_TYPE_DIALOG . :dialog)
        (:_NET_WM_WINDOW_TYPE_NORMAL . :normal))
   */

    Display *d =  XOpenDisplay(0); //QX11Info::display();
    Atom nameAtom = XInternAtom(d, "_NET_WM_WINDOW_TYPE", false);
    Atom type;
    int format;
    unsigned long nitems, after;
    unsigned char *data;
    int status;

    status = XGetWindowProperty(d, window, nameAtom, 0L, LONG_MAX,
                                         false, XA_ATOM, &type, &format,
                                         &nitems, &after, &data);
    //if (status != Success)
    if (nitems == 0)
    {
        data = this->windowProperty(d, window, "_OB_APP_TYPE", &nitems, &status);

        XFlush(d);
        XCloseDisplay(d);

        if (nitems != 0)
        {
            if (QString((char *)data) == "normal") return "_NET_WM_WINDOW_TYPE_NORMAL";
        }
        return "unknow";
    }

    Atom prop = ((Atom *)data)[0];
    data = (unsigned char *)XGetAtomName(d, prop);
    XFlush(d);
    XCloseDisplay(d);
    return (char *)data;
}

unsigned char* Xlibutil::xwindowState(Window window)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    Atom nameAtom = XInternAtom(d,"_NET_WM_STATE", True);
    Atom type;
    int format;
    unsigned long nitems, after;
    unsigned char *data = 0;
    int status;

    status = XGetWindowProperty(d, window, nameAtom, 0L, LONG_MAX,
                                         false, XA_ATOM, &type, &format,
                                         &nitems, &after, &data);

    //if (status != Success)
    if (nitems == 0)
    {
        XFlush(d);
        XCloseDisplay(d);
        return (unsigned char *)"unknow";
    }

    Atom prop = ((Atom *)data)[0];
    data = (unsigned char *)XGetAtomName(d, prop);
    XFlush(d);
    XCloseDisplay(d);
    return data;
}

char* Xlibutil::xwindowClass(Window window)
{
//    Display *d = XOpenDisplay(0);
//    XClassHint *classhint;
//    int status;
//    status = XGetClassHint(d, window, classhint);

//    if (status != Success)
//    {
//        XFlush(d);
//        XCloseDisplay(d);
//        return NULL;
//    }

//    XFlush(d);
//    XCloseDisplay(d);

//    return classhint->res_name;

    Display *d = XOpenDisplay(0); //QX11Info::display();
    int status;
    unsigned long nitems;
    unsigned char* data;
    data = this->windowProperty(d, window, "WM_CLASS", &nitems, &status);

    //if (status != Success)
    if (nitems == 0)
    {
        XFlush(d);
        XCloseDisplay(d);
        return "unknow";
    }

    XFlush(d);
    XCloseDisplay(d);
    return (char*)data;
}

char* Xlibutil::xwindowName(Window window)
{
     Display *d = XOpenDisplay(0); //QX11Info::display();
     Atom nameAtom = XInternAtom(d, "_NET_WM_NAME", false);
     Atom utf8Atom = XInternAtom(d, "UTF8_STRING", false);
     Atom type;
     int format;
     unsigned long nitems, after;
     unsigned char *data;
     int status;

    status = XGetWindowProperty(d, window, nameAtom, 0, 65536,
                                         false, utf8Atom, &type, &format,
                                         &nitems, &after, &data);

    //if (status != Success)
    if (nitems == 0)
    {
        XFlush(d);
        XCloseDisplay(d);
        return "unknow";
    }

    XFlush(d);
    XCloseDisplay(d);
    return (char *)data;
}

int Xlibutil::xwindowPid(Window window)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    unsigned char *data;
    unsigned long nitems;
    int window_pid = 0;
    int status;

    data = this->windowProperty(d, window, "_NET_WM_PID", &nitems, &status);
    window_pid = (int) *((unsigned long *)data);

    //if (status != Success)
    if (nitems == 0)
    {
        XFlush(d);
        XCloseDisplay(d);
        return 0;
    }

    XFlush(d);
    XCloseDisplay(d);
    return window_pid;
}

unsigned char* Xlibutil::windowProperty(Display *d, Window window, const char *arg, unsigned long *nitems, int *status)
{
    Atom type;
    int size, actual_format;
    //unsigned long nitems;
    unsigned char *data;

    /*unsigned long nbytes;*/
    unsigned long bytes_after; /* unused */

    Atom tmp = XInternAtom(d, arg, False);
    // 4096 / 4 , (~0L)

    *status = XGetWindowProperty(d, window,tmp, 0, LONG_MAX,
                                  False, AnyPropertyType, &type,
                                  &actual_format, nitems, &bytes_after,
                                  &data);
    //if (status != Success)
    if (nitems == 0)
    {
        XFlush(d);
        return 0x0;
    }

    XFlush(d);
    return data;
}

XWindowAttributes Xlibutil::attrWindow(Display *d, Window window)
{
    XWindowAttributes attr;
    XGetWindowAttributes(d, window, &attr);
    XFlush(d);
    return attr;
}

void Xlibutil::resizeWindow(Display *d, Window window, int x, int y, unsigned int w, unsigned int h)
{
    XMoveResizeWindow(d, window, x, y, w, h);
    XFlush(d);
}

void Xlibutil::xactive(Window window)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    XEvent xev;
    Atom wm_state  =  XInternAtom(d, "_NET_ACTIVE_WINDOW", False);
    Atom win_min  =  XInternAtom(d, "_NET_ACTIVE_WINDOW", False);

    memset(&xev, 0, sizeof(xev));
    xev.type = ClientMessage;
    xev.xclient.window = window;
    xev.xclient.message_type = wm_state;
    xev.xclient.format = 32;
    xev.xclient.data.l[0] = win_min;
    xev.xclient.data.l[1] = CurrentTime;

    XSendEvent(d, DefaultRootWindow(d), False, SubstructureRedirectMask|SubstructureNotifyMask, &xev);
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xminimize(Window window)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    int screen;
    XWindowAttributes attr = this->attrWindow(d, window);
    screen = XScreenNumberOfScreen(attr.screen);
    XIconifyWindow(d, window, screen);
    XFlush(d);
    XCloseDisplay(d);
}

Window* Xlibutil::xgetWindows(Window win, unsigned long *size)
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long bytes_after;
        unsigned char *prop = 0x0;
        //4096 / 4
        //LONG_MAX

        int status = XGetWindowProperty(d, win, atom, 0, LONG_MAX, False, AnyPropertyType, &actual_type, &actual_format, size, &bytes_after, &prop);

        if (status != Success)
        {
            XFlush(d);
            XCloseDisplay(d);
            return NULL;
        }

        //Window *lists = (Window *)((unsigned long *)prop);
        XFlush(d);
        XCloseDisplay(d);
        return (Window *)((unsigned long *)prop);
    }

    XFlush(d);
    XCloseDisplay(d);
    return NULL;
}

Window* Xlibutil::xwindows(unsigned long *size)
{
/*
    Window parent;
    Window *children;
    Window *children_ = (Window *)malloc(sizeof(Window) * 100);
    int error;
    int add = 0;
    unsigned int len;
    error = XQueryTree(display, DefaultRootWindow(display), &DefaultRootWindow(display), &parent, &children, &len);

    for (int i = 0; i < len; i++)
    {
        if (this->xwindowName(children[i]) != "unknow")
        {
            children_[add] = children[i];
            add++;
        }
    }
    *size = add;
    return children_;*/

    Display *d = XOpenDisplay(0); //QX11Info::display();
    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long bytes_after;
        unsigned char *prop = 0x0;
        //4096 / 4
        //LONG_MAX

        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, LONG_MAX, False, AnyPropertyType, &actual_type, &actual_format, size, &bytes_after, &prop);

        if (status != Success)
        {
            XFlush(d);
            XCloseDisplay(d);
            return NULL;
        }

        //Window *lists = (Window *)((unsigned long *)prop);
        XFlush(d);
        XCloseDisplay(d);
        return (Window *)((unsigned long *)prop);
    }

    XFlush(d);
    XCloseDisplay(d);
    return NULL;
}

Window Xlibutil::xwindowID(int pid)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long nitems;
        unsigned long bytes_after;
        unsigned char *prop;

        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, 4096 / 4, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

        Window *lists = (Window *)((unsigned long *)prop);

        for (int i = 0; i < nitems; i++)
        {
            if (pid == this->xwindowPid(lists[i]))
            {
                XFree(prop);
                XFlush(d);
                XCloseDisplay(d);
                return lists[i];
            }
        }
    }

    XFlush(d);
    XCloseDisplay(d);
    return NULL;
}

Window Xlibutil::xwindowIdByClass(QString wmclass)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long nitems;
        unsigned long bytes_after;
        unsigned char *prop;

        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, 4096 / 4, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

        Window *lists = (Window *)((unsigned long *)prop);

        for (int i = 0; i < nitems; i++)
        {
            if (wmclass == QString(this->xwindowClass(lists[i])).toLower())
            {
                XFree(prop);
                XFlush(d);
                XCloseDisplay(d);
                return lists[i];
            }
        }
    }

    XFlush(d);
    XCloseDisplay(d);
    return NULL;
}

bool Xlibutil::xsingleActive(QString wmclass)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();
    Atom atom = XInternAtom(d, "_NET_ACTIVE_WINDOW", True);
    Atom actual_type;
    int actual_format;
    unsigned long nitems;
    unsigned long bytes_after;
    unsigned char *prop;

    int status = XGetWindowProperty(d, this->xwindowIdByClass(wmclass), atom, 0, 4096 / 4, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

    //if ((unsigned char*)prop != 0x0)
    if (nitems == 0)
    {
        XFlush(d);
        XCloseDisplay(d);
        return true;
    }

    XFree(prop);
    XFlush(d);
    XCloseDisplay(d);
    return false;
}

bool Xlibutil::xisActive(QString wmclass)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_ACTIVE_WINDOW", True);
        Atom actual_type;
        int actual_format;
        unsigned long nitems;
        unsigned long bytes_after;
        unsigned char *prop;

        //4096 / 4
        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, LONG_MAX, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

        Window *lists = (Window *)((unsigned long *)prop);

        for (int i = 0; i < nitems; i++)
        {
            if (wmclass == QString(this->xwindowClass(lists[i])).toLower())
            {
                XFree(prop);
                XFlush(d);
                XCloseDisplay(d);
                return 1;
            }
        }
    }

    XFlush(d);
    XCloseDisplay(d);
    return 0;
}

void Xlibutil::xwindowUnmap(Window win)
{
    Display *d = XOpenDisplay(0);
    XUnmapWindow(d, win);
    //XMapRaised(d, win);
    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xwindowMap(Window win)
{
    Display *d = XOpenDisplay(0);
    XMapWindow(d, win);
    XMapRaised(d, win);
    XSync(d, false);
    XCloseDisplay(d);
}

void Xlibutil::xminimizeByClass(QString wmclass)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long nitems;
        unsigned long bytes_after;
        unsigned char *prop;

        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, 4096 / 4, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

        Window *lists = (Window *)((unsigned long *)prop);

        for (int i = 0; i < nitems; i++)
        {
            if (wmclass == QString(this->xwindowClass(lists[i])).toLower())
            {
                this->xminimize(lists[i]);
            }
        }

        XFree(prop);
        XFlush(d);
    }

    XCloseDisplay(d);
}

void Xlibutil::xactiveByClass(QString wmclass)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long nitems;
        unsigned long bytes_after;
        unsigned char *prop;

        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, 4096 / 4, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

        Window *lists = (Window *)((unsigned long *)prop);

        for (int i = 0; i < nitems; i++)
        {
            if (wmclass == QString(this->xwindowClass(lists[i])).toLower())
            {
                this->xactive(lists[i]);
            }
        }

        XFlush(d);
        XFree(prop);
    }

    XCloseDisplay(d);
}

bool Xlibutil::xwindowExist(QString wmclass)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    if (d)
    {
        Atom atom = XInternAtom(d, "_NET_CLIENT_LIST", True);
        Atom actual_type;
        int actual_format;
        unsigned long nitems;
        unsigned long bytes_after;
        unsigned char *prop;

        int status = XGetWindowProperty(d, DefaultRootWindow(d), atom, 0, 4096 / 4, False, AnyPropertyType, &actual_type, &actual_format, &nitems, &bytes_after, &prop);

        Window *lists = (Window *)((unsigned long *)prop);

        for (int i = 0; i < nitems; i++)
        {
            if (wmclass == QString(this->xwindowClass(lists[i])).toLower())
            {
                XFree(prop);
                XFlush(d);
                XCloseDisplay(d);
                return true;
            }
        }

        XFlush(d);
        XFree(prop);
    }

    XCloseDisplay(d);
    return false;
}

QString Xlibutil::xwindowLauncher(Window window)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();
    unsigned char *data;
    unsigned long nitems;
    QString launcher;
    int status;

    data = this->windowProperty(d, window, "_BAMF_DESKTOP_FILE", &nitems, &status);
    launcher = (char *)data;

    if (nitems == 0)
    {
        XFlush(d);
        XCloseDisplay(d);
        return "";
    }

    XFlush(d);
    XCloseDisplay(d);

    return launcher;
}

void Xlibutil::addDesktopFile(int pid, QString arg)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    //unsigned char* deskfile = (unsigned char*)"/usr/share/applications/xfce4-terminal.desktop";
    unsigned char* deskfile = (unsigned char*)arg.toUtf8().constData();
    int status;

    if(d)
    {
        Atom atom = XInternAtom(d, "_BAMF_DESKTOP_FILE", False);
        status = XChangeProperty(d, this->xwindowID(pid), atom, XA_STRING, 8, PropModeReplace, deskfile, arg.length());
    }

    XFlush(d);
    XCloseDisplay(d);
}

void Xlibutil::xaddDesktopFile(Window id, QString arg)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();

    //unsigned char* deskfile = (unsigned char*)"/usr/share/applications/xfce4-terminal.desktop";
    unsigned char* deskfile = (unsigned char*)arg.toUtf8().constData();
    int status;

    if(d)
    {
        Atom atom = XInternAtom(d, "_BAMF_DESKTOP_FILE", False);
        status = XChangeProperty(d, id, atom, XA_STRING, 8, PropModeReplace, deskfile, arg.length());
    }

    XFlush(d);
    XCloseDisplay(d);
}

QPixmap Xlibutil::xwindowIcon(Window window)
{
    Display *d = XOpenDisplay(0);
    QPixmap map;

    XWindowAttributes attr;
    if (!XGetWindowAttributes(d, window, &attr))
    {
        //qWarning() << "Paint error" << this->xwindowClass(window);
        return map;
    }

    QImage image;
    XImage* ximage = XGetImage(d, window, 0, 0, attr.width, attr.height, AllPlanes, ZPixmap);

    if(ximage)
    {
        image = QImage((const uchar*) ximage->data, ximage->width, ximage->height, ximage->bytes_per_line,  QImage::Format_ARGB32_Premultiplied);
        image = image.scaled(QSize(24, 24), Qt::KeepAspectRatio, Qt::SmoothTransformation);
        map.fromImage(image);
        return map;
    }

    return map;
}

QPixmap Xlibutil::xwindowTrayIcon(Window window)
{
    Display *d = XOpenDisplay(0);//QX11Info::display();
    Atom type;
    int format;
    unsigned long bytes_after;
    ulong* data;
    unsigned long nitems;

    Atom prop = XInternAtom(d, "_NET_WM_ICON", False);
    //LONG_MAX
    XGetWindowProperty(d, window, prop, 0, UINT32_MAX, False, AnyPropertyType,
                       &type, &format, &nitems, &bytes_after, (uchar**)&data);

    QPixmap map;

    if (data != 0x0)
    {
        QImage image(data[0], data[1], QImage::Format_ARGB32_Premultiplied);

        for (int i = 0; i < image.byteCount() / 4; ++i)
        {
            //uint*
            ((uint32_t *)image.bits())[i] = data[i + 2];
        }

        image = image.scaled(QSize(24, 24), Qt::KeepAspectRatio, Qt::SmoothTransformation);
        map.convertFromImage(image);
        //map = map.scaled(42, 42, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);
        //map = map.scaled(42, 42, Qt::KeepAspectRatioByExpanding, Qt::SmoothTransformation);
    }

    XFree(data);
    XFlush(d);
    XCloseDisplay(d);
    return map;
}
