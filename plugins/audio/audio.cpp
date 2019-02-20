#include "audio.h"



int Audio::volume()
{
    /*
    QProcess *process = new QProcess();
    process->start("amixer get Master");
    process->waitForFinished();
    QString result = process->readAll();
    result = result.split("%]")[0].split("[")[1];
    process->close();
    return result.toInt();*/

    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    return settings.value("volume").toInt();
}

void Audio::volume(QString valor)
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    settings.setValue("volume", valor.toInt());

    QProcess process;
    valor = valor.append("%");
    process.start("amixer set Master " + valor);
    process.waitForFinished();
    process.close();
}

int Audio::micro()
{
    /*
    QProcess *process = new QProcess();
    process->start("amixer get Capture");
    process->waitForFinished();
    QString result = process->readAll();
    result = result.split("%]")[0].split("[")[1];
    process->close();
    return result.toInt();*/

    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    return settings.value("micro").toInt();
}

void Audio::micro(QString valor)
{
    QDir dir;
    QString path = dir.homePath() + "/.config/Synth/panel/";
    QSettings settings(path + "settings.txt", QSettings::NativeFormat);
    settings.setValue("micro", valor.toInt());

    QProcess process;
    valor = valor.append("%");
    process.start("amixer set Capture " + valor);
    process.waitForFinished();
    process.close();
}
