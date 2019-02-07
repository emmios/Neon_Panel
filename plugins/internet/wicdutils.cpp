#include "wicdutils.h"

Wicdutils::Wicdutils()
{

}

//void Wicdutils::Scan()
//{
//    QDBusInterface wireless("org.wicd.daemon",
//                                "/org/wicd/daemon/wireless",
//                                  "org.wicd.daemon.wireless", this->bus);
//    wireless.call("Scan");
//}

//void Wicdutils::AsyncScan()
//{
//    QDBusInterface wireless("org.wicd.daemon",
//                                "/org/wicd/daemon/wireless",
//                                  "org.wicd.daemon.wireless", this->bus);
//    wireless.asyncCall("Scan");
//}

//void Wicdutils::asyncScan()
//{
//    QDBusInterface wireless("org.wicd.daemon",
//                                "/org/wicd/daemon/wireless",
//                                  "org.wicd.daemon.wireless", this->bus);
//    wireless.asyncCall("Scan");
//}

void Wicdutils::scan()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    wireless.call("Scan");
}

int Wicdutils::getNumberOfNetworks()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    return wireless.call("GetNumberOfNetworks").arguments().at(0).toInt();
}

QString Wicdutils::getWirelessProperty(int network, QString prop)
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    return wireless.call("GetWirelessProperty", network, prop).arguments().at(0).toString();
}

QString Wicdutils::getWirelessProperties()
{
    QString prop;
    int count = 0;

    for (int i = 0; i < this->getNumberOfNetworks(); i++)
    {
        if (count >= 1) prop += ";";
        prop += QString::number(count) + ",";
        prop += this->getWirelessProperty(count, "essid") + ",";
        prop += this->getWirelessProperty(count, "bssid") + ",";
        prop += this->getWirelessProperty(count, "encryption") + ",";
        prop += this->getWirelessProperty(count, "quality") + ",";
        prop += this->getWirelessProperty(count, "encryption_method") + ",";
        prop += this->getWirelessProperty(count, "channel") + ",";
        prop += this->getWirelessProperty(count, "key");
        count++;
    }

    return prop;
}

QString Wicdutils::getWirelessProperties(int network)
{
    QString prop;

    prop += this->getWirelessProperty(network, "essid") + ",";
    prop += this->getWirelessProperty(network, "bssid") + ",";
    prop += this->getWirelessProperty(network, "encryption") + ",";
    prop += this->getWirelessProperty(network, "quality") + ",";
    prop += this->getWirelessProperty(network, "encryption_method") + ",";
    prop += this->getWirelessProperty(network, "channel") + ",";
    prop += this->getWirelessProperty(network, "key");

    return prop;
}

QString Wicdutils::getCurrentNetwork()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    return wireless.call("GetCurrentNetwork").arguments().at(0).value<QString>();
}

void Wicdutils::setWirelessProperty(int network, QString prop, QString value)
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    wireless.call("SetWirelessProperty", network, prop, value);
}

QString Wicdutils::getApBssid()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
   return wireless.call("GetApBssid").arguments().at(0).toString();
}

QString Wicdutils::getWirelessIP()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    return wireless.call("GetWirelessIP").arguments().at(0).toString();
}

void Wicdutils::deleteWirelessNetwork(QString essid)
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    wireless.call("DeleteWirelessNetwork", essid);
}

QString Wicdutils::getWirelessInterfaces()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    return wireless.call("GetWirelessInterfaces").arguments().at(0).toString();
}

void Wicdutils::saveWirelessNetworkProfile(int network)
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    wireless.call("SaveWirelessNetworkProfile", network);
}

void Wicdutils::connectWireless(int network)
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    wireless.call("ConnectWireless", network);
}

void Wicdutils::disconnectWireless()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    wireless.call("DisconnectWireless");
}

void Wicdutils::autoConnect()
{
    QDBusInterface daemon("org.wicd.daemon",
                                "/org/wicd/daemon",
                                  "org.wicd.daemon", this->bus);
    daemon.call("AutoConnect");
}

QString Wicdutils::checkIfWirelessConnecting()
{
    QDBusInterface wireless("org.wicd.daemon",
                                "/org/wicd/daemon/wireless",
                                  "org.wicd.daemon.wireless", this->bus);
    return wireless.call("CheckIfWirelessConnecting").arguments().at(0).toString();
}
