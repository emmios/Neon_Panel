#include "audio.h"



int Audio::volume()
{
    QProcess *process = new QProcess();
    process->start("amixer get Master");
    process->waitForFinished();
    QString result = process->readAll();
    result = result.split("%]")[0].split("[")[1];
    process->close();
    return result.toInt();
}

void Audio::volume(QString valor)
{
    QProcess process;
    valor = valor.append("%");
    process.start("amixer set Master " + valor);
    process.waitForFinished();
    process.close();
}

int Audio::micro()
{
    QProcess *process = new QProcess();
    process->start("amixer get Capture");
    process->waitForFinished();
    QString result = process->readAll();
    result = result.split("%]")[0].split("[")[1];
    process->close();
    return result.toInt();
}

void Audio::micro(QString valor)
{
    QProcess process;
    valor = valor.append("%");
    process.start("amixer set Capture " + valor);
    process.waitForFinished();
    process.close();
}
