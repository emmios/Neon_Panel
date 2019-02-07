#include "internet.h"


void Internet::scan()
{
   wicd.asyncScan();
}

QString Internet::getRedes()
{
    return wicd.getWirelessProperties();
}

QString Internet::getConnected()
{
    return wicd.getCurrentNetwork();
}

void Internet::connect(int network)
{
    wicd.connectWireless(network);
}

void Internet::disconnect()
{
    wicd.disconnectWireless();
}

