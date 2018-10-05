#ifndef INTERNET_H
#define INTERNET_H

#include <QProcess>
#include <QStringList>
#include <QDebug>

#include "wicdutils.h"


class Internet
{

public:
    void scan();
    QString getRedes();
    QString getConnected();
    void connect(int network);
    void disconnect();
    Wicdutils wicd;
};

#endif // INTERNET_H
