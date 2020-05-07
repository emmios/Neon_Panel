#ifndef BRIGHTNESS_H
#define BRIGHTNESS_H

#include <QDebug>
#include <QFile>
#include <QFileInfoList>
#include <QDir>
#include <QTextStream>
#include <QProcess>
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

class Brightness
{
public:
    double format(int bright);
    void brightness(int bright);
    int brightness();
    int maxBrightness();
};

#endif // BRIGHTNESS_H
