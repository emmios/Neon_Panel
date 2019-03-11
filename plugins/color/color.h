#ifndef COLOR_H
#define COLOR_H

#include <QObject>
#include <QColor>
#include <QDebug>
#include <QDir>
#include <QSettings>
#include <QString>
#include <QStringList>


class Color
{
public:
    Color();
    int changeDetail();
    int changeLight();
    QString changeLight(int value, int hue, int light);
    QString changeDetail(int value, int hue, int light);
    void color(QString cor);
};

#endif // COLOR_H
