#ifndef WICD_H
#define WICD_H

#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusMessage>
#include <QDebug>
#include <QString>
#include <QStringList>
#include <QObject>

class Wicdutils
{
public:
    Wicdutils();
//    static void Scan();
//    static void AsyncScan();
    //    void asyncScan();
    void scan();
    int getNumberOfNetworks();
    QString getWirelessProperty(int network, QString prop);
    QString getWirelessProperties();
    QString getWirelessProperties(int network);
    QString getCurrentNetwork();
    void setWirelessProperty(int network, QString prop, QString value);
    QString getApBssid();
    QString getWirelessIP();
    void deleteWirelessNetwork(QString essid);
    QString getWirelessInterfaces();
    void saveWirelessNetworkProfile(int network);
    void connectWireless(int network);
    void disconnectWireless();
    void autoConnect();
    QString checkIfWirelessConnecting();

private:
    QDBusConnection bus = bus.systemBus();
};

#endif // WICD_H
