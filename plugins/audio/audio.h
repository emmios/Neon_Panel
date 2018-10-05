#ifndef AUDIO_H
#define AUDIO_H

#include <QProcess>
#include <QDebug>


class Audio
{
public:
    int volume();
    int micro();
    void volume(QString valor);
    void micro(QString valor);
};

#endif // AUDIO_H
