#include "tela.h"


Tela::Tela()
{

}

int Tela::getDesktopsCount()
{
    Display *d = XOpenDisplay(0); //QX11Info::display();
    int num = ScreenCount(d);
    XCloseDisplay(d);

    if (num == 0 || num == NULL) {
        QDir dir("/tmp/.X11-unix/");
        QFileInfoList filelist = dir.entryInfoList(QDir::System | QDir::NoDot | QDir::NoDotAndDotDot);
        return filelist.length();
    }

    return num;
}

void Tela::displayChange(int num)
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

    //XFlush(d);
    XCloseDisplay(d);
}
