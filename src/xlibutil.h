#ifndef XUTIL_H
#define XUTIL_H

#include <QX11Info>
#include <QWindow>
#include <QScreen>
#include <QDebug>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QThread>
#include <QPixmap>
#include <QRect>
#include <QSize>
#include <QImage>
#include <QWindow>

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/extensions/Xdamage.h>
#include <X11/extensions/Xinerama.h>
#include <X11/extensions/Xcomposite.h>
#include <X11/extensions/Xrender.h>
#include <xcb/xcb_event.h>


#define ALL_DESKTOPS 0xFFFFFFFF


class Xlibutil
{

public:
    Xlibutil();
    void xactive(Window window);
    void xminimize(Window window);
    Window* xwindows(unsigned long *size);
    Window* xgetWindows(Window win, unsigned long *size);
    int xwindowPid(Window window);
    char* xwindowClass(Window window);
    char* xwindowName(Window window);
    char* xwindowType(Window window);
    unsigned char* xwindowState(Window window);
    Window xwindowID(int pid);
    void xwindowUnmap(Window win);
    void xwindowMap(Window win);
    void xminimizeByClass(QString wmclass);
    void xactiveByClass(QString wmclass);
    bool xwindowExist(QString wmclass);
    bool xisActive(QString wmclass);
    Window xwindowIdByClass(QString wmclass);
    bool xsingleActive(QString wmclass);
    void xchange(Window window, const char * atom);
    void xreservedSpace(Window window, int h);
    unsigned char* windowProperty(Display *display, Window window, const char *arg, unsigned long *nitems, int *status);
    QString xwindowLauncher(Window window);
    void addDesktopFile(int pid, QString arg);
    void xaddDesktopFile(Window id, QString arg);
    XWindowAttributes attrWindow(Display *display, Window window);
    void resizeWindow(Display *display, Window window, int x, int y, unsigned int w, unsigned int h);
    void xwindowClose(Window window);
    void xwindowKill(Window window);
    void xchangeProperty(Window window, const char * atom, const char * internalAtom, int format);
    void xchangeProperty(Window window, int atom, const char * internalAtom, int format);
    void openboxChange(Window window, long atom);
    int xwindowMove(Window win, int x, int y, int w, int h);
    //QPixmap xwindowIcon(Window window);
    //QPixmap xwindowTrayIcon(Window window);
    QPixmap xwindowScreenShot(Window window, bool argb = false);
    QPixmap xwindowIcon(Window window, QSize size, bool smooth = false);
    Atom atom(const char* atomName);
    QString xgetWindowFocused();
    int xgetWindowFocusedId();
    void displayChange(int num);
    void setMoreDisplay(int num);
    int numberOfscreens();

private:
    QThread t;
    //Display *display = QX11Info::display();
};

#endif // XUTIL_H
