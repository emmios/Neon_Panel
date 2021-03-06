#ifndef CONTEXTPLUGIN_H
#define CONTEXTPLUGIN_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVector>

#include "plugins/audio/audio.h"
#include "plugins/brightness/brightness.h"
#include "plugins/internet/wicdutils.h"
#include "plugins/tela/tela.h"
#include "plugins/power/power.h"
#include "plugins/color/color.h"


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
    Q_INVOKABLE void displayChange(int num);

    Q_INVOKABLE void shutdown();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void suspend();
    Q_INVOKABLE void logoff();
    Q_INVOKABLE int changeLight();
    Q_INVOKABLE int changeDetail();
    Q_INVOKABLE QString changeLight(int value, int hue, int light);
    Q_INVOKABLE QString changeDetail(int value, int hue, int light);
    Q_INVOKABLE void color(QString cor);
    Q_INVOKABLE int hasBattery();
    Q_INVOKABLE int isPlugged();
};

#endif // CONTEXTPLUGIN_H
