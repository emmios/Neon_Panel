#include "brightness.h"


void Brightness::brightness(int bright)
{
    Display *display = XOpenDisplay(0);
    Atom backlight = XInternAtom (display, "Backlight", True);
    int screen = 0, o = 0, status = 0;
    Window root = DefaultRootWindow(display);
    XRRScreenResources *resources = XRRGetScreenResources(display, root);
    RROutput output = resources->outputs[o];
    XRRPropertyInfo *info = XRRQueryOutputProperty(display, output, backlight);
    double min, max;
    long value;

    //qDebug() << value << " - " << info->values[0] << " - " << info->values[1];

    if (info != NULL)
    {
        min = info->values[0];
        max = info->values[1];
        XFree(info);
        XFree(resources);

        bright = (bright * max) / 100;

        value = QString::number(bright).toInt();

        XRRChangeOutputProperty(display, output, backlight, XA_INTEGER,
                                32, PropModeReplace, (unsigned char *) &value, 1);

        //XFlush(display);
    }

    XCloseDisplay(display);
}

int Brightness::brightness()
{
    QString path = "/sys/class/backlight/";
    QDir dir(path);
    QFileInfoList infolist = dir.entryInfoList(QDir::Dirs | QDir::NoDot | QDir::NoDotAndDotDot);

    QFile f(path + infolist.at(0).fileName() + "/brightness");

    if(f.open(QFile::ReadOnly))
    {
        return f.readLine().replace("\n", "").toInt();
    }
    else
    {
        return 0;
    }
}

int Brightness::maxBrightness()
{
    QString path = "/sys/class/backlight/";
    QDir dir(path);
    QFileInfoList infolist = dir.entryInfoList(QDir::Dirs | QDir::NoDot | QDir::NoDotAndDotDot);

    QFile f(path + infolist.at(0).fileName() + "/max_brightness");

    if(f.open(QFile::ReadOnly))
    {
        return f.readLine().replace("\n", "").toInt();
    }
    else
    {
        return 0;
    }
}
