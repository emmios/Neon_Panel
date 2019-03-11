#include "color.h"

Color::Color()
{

}


QString Color::changeLight(int value, int hue, int light)
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    settings.setValue("brightness", value);

    QColor color;
    //115
    color = color.fromHsl(hue, 255, light, 255);
    return color.name();
}

QString Color::changeDetail(int value, int hue, int light)
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    settings.setValue("hue", value);

    QColor color;
    //115
    color = color.fromHsl(hue, 255, light, 255);
    return color.name();
}

int Color::changeLight()
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    int bright = settings.value("brightness").toInt();
    if (bright == 0) bright = 55;
    return bright;
}

int Color::changeDetail()
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    int hue = settings.value("hue").toInt();
    if (hue == 0) hue = 59;
    return hue;
}

void Color::color(QString cor)
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    settings.setValue("color", cor);
}
