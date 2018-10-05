#ifndef CONTEXTPLUGIN_H
#define CONTEXTPLUGIN_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVector>

//#include "plugins/display/_display.h"
#include "plugins/audio/audio.h"
#include "plugins/brightness/brightness.h"
#include "plugins/internet/wicdutils.h"



class ContextPlugin : public QObject
{

    Q_OBJECT

public:
    Q_INVOKABLE int volume();
    Q_INVOKABLE void volume(QString valor);
    Q_INVOKABLE int micro();
    Q_INVOKABLE void micro(QString valor);

    Q_INVOKABLE void brightness(int bright);
    Q_INVOKABLE int brightness();

    Q_INVOKABLE QString redes();
    Q_INVOKABLE void connectWireless(int network);
    Q_INVOKABLE QString getCurrentNetwork();
    Q_INVOKABLE void disconnectWireless();
    Q_INVOKABLE void setWirelessProperty(int network, QString prop, QString value);
    Q_INVOKABLE QString checkIfWirelessConnecting();
    Q_INVOKABLE QString getWirelessIP();
    Q_INVOKABLE void scan();
    Q_INVOKABLE int getDesktopsCount();
};

#endif // CONTEXTPLUGIN_H
