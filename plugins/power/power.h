#ifndef POWER_H
#define POWER_H

#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QString>
#include <QDebug>

#include <unistd.h>
#include <linux/reboot.h>
#include <sys/reboot.h>


class Power
{
public:
    Power();
    void shutdown();
    void restart();
    void suspend();
    void logoff();
};

#endif // POWER_H
