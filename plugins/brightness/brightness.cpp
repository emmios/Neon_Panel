#include "brightness.h"


double Brightness::format(int bright)
{
    QString valor =  QString::number((bright * 200) / 2.0);
    double val = 1.0;

    if (valor.length() < 5)
    {
        if (valor.length() <= 3)
        {
            val = 0.1;
        }
        else
        {
            QString num = "0.";
            num.append(valor[0]);
            num.append(valor[0]);
            val = num.toDouble();
        }
    }
    else
    {
        QString num;
        num.append(valor[0]);
        num.append(".");
        num.append(valor[1]);
        num.append(valor[2]);
        val = num.toDouble();
    }

    return val;
}

void Brightness::brightness(int bright)
{
    /*
    Display *display = XOpenDisplay(0);
    Atom backlight;

    #ifdef RR_PROPERTY_BACKLIGHT
      backlight = XInternAtom(display, RR_PROPERTY_BACKLIGHT, True);
    #endif
    if (backlight == NULL) backlight = XInternAtom(display, "BACKLIGHT", True);

    Window root = DefaultRootWindow(display);
    XRRScreenResources *resources = XRRGetScreenResources(display, root);
    RROutput output = resources->outputs[0];
    XRRPropertyInfo *info = XRRQueryOutputProperty(display, output, backlight);

    //for (int i = 0; i < resources->noutput; i++)
    //{
    //    XRROutputInfo *output_info = XRRGetOutputInfo(display, resources, resources->outputs[i]);
    //    info = XRRQueryOutputProperty(display, resources->outputs[i], backlight);
    //    qDebug() << info << resources->outputs[i] << output_info->name << output_info->nmode;
    //}

    double min = 0, max = 0;
    long value;
    qDebug() << value << " - " << info << resources->noutput; //<< info->values[0] << " - " << info->values[1];
    XFree(resources);

    if (info != NULL)
    {
        min = info->values[0];
        max = info->values[1];
        XFree(info);
    }

        //bright = (bright * max) / 100;
    value = format(bright) * (max - min) + min;
        //value = QString::number(bright).toInt();

        qDebug() << "int:" << (92 * max) / 100;
        qDebug() << "double:" << format(bright) * (max - min) + min;

   XRRChangeOutputProperty(display, output, backlight, XA_INTEGER,
                        32, PropModeReplace, (unsigned char *) &value, 1);


    XCloseDisplay(display);*/

    QProcess process;
    QStringList list;
    list << "--listmonitors";
    process.start("xrandr", list);
    process.waitForFinished();
    QString result = process.readAll();
    QStringList parts = result.split("\n");
    process.close();
    if (!parts.isEmpty())
    {
        list.clear();
        list << "--output";
        for (int i = 1; i < parts.length(); i++)
        {
            QString name = parts.at(1).split(" +*")[1].split(" ")[0];
            if (!name.isEmpty())
            {
                list << name;
                list << "--brightness";
                list << QString::number(format(bright));
                process.start("xrandr", list);
                process.waitForFinished();
            }
        }
    }
}

int Brightness::brightness()
{
    /*
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
    }*/
    return 100;
}

int Brightness::maxBrightness()
{
    /*
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
    }*/
    return 200;
}
