#include "contextplugin.h"

// Audio

int ContextPlugin::volume()
{
    Audio audio;
    return audio.volume();
}

void ContextPlugin::volume(QString valor)
{
    Audio audio;
    audio.volume(valor);
}

int ContextPlugin::micro()
{
    Audio audio;
    audio.micro();
}

void ContextPlugin::micro(QString valor)
{
    Audio audio;
    audio.micro(valor);
}

// Brightness

void ContextPlugin::brightness(int bright)
{
    Brightness brightness;
    brightness.brightness(bright);
}

int ContextPlugin::brightness()
{
    Brightness brightness;
    return brightness.brightness();
}

// wifi

QString ContextPlugin::redes()
{
    //"0,world wide web,78:44:76:1D:16:06,true,98,WPA2,11,kamikazi3200;1,LG K4 Lite (NOVO),4A:60:5F:0C:5E:34,true,58,WPA2,1,"
    Wicdutils wicd;
    return wicd.getWirelessProperties();
}

void ContextPlugin::connectWireless(int network)
{
    Wicdutils wicd;
    wicd.connectWireless(network);
}

QString ContextPlugin::getCurrentNetwork()
{
    Wicdutils wicd;
    return wicd.getCurrentNetwork();
}

void ContextPlugin::disconnectWireless()
{
    Wicdutils wicd;
    wicd.disconnectWireless();
}

void ContextPlugin::setWirelessProperty(int network, QString prop, QString value)
{
    Wicdutils wicd;
    wicd.setWirelessProperty(network, prop, value);
}

QString ContextPlugin::checkIfWirelessConnecting()
{
    Wicdutils wicd;
    return wicd.checkIfWirelessConnecting();
}

void ContextPlugin::scan()
{
    Wicdutils wicd;
    wicd.scan();
}

QString ContextPlugin::getWirelessIP()
{
    Wicdutils wicd;
    return wicd.getWirelessIP();
}

//display

int ContextPlugin::getDesktopsCount()
{
    Tela tela;
    return tela.getDesktopsCount();
}

void ContextPlugin::displayChange(int num)
{
    Tela tela;
    tela.displayChange(num);
}

//power

void ContextPlugin::shutdown()
{
    Power power;
    power.shutdown();
}

void ContextPlugin::restart()
{
    Power power;
    power.restart();
}

void ContextPlugin::suspend()
{
    Power power;
    power.suspend();
}

void ContextPlugin::logoff()
{
    Power power;
    power.logoff();
}

int ContextPlugin::hasBattery()
{
    Power power;
    return power.hasBattery();
}

int ContextPlugin::isPlugged()
{
    Power power;
    return power.isPlugged();
}

//Color

int ContextPlugin::changeLight()
{
    Color color;
    return color.changeLight();
}

int ContextPlugin::changeDetail()
{
    Color color;
    return color.changeDetail();
}

QString ContextPlugin::changeLight(int value, int hue, int light)
{
    Color color;
    return color.changeLight(value, hue, light);
}

QString ContextPlugin::changeDetail(int value, int hue, int light)
{
    Color color;
    return color.changeDetail(value, hue, light);
}

void ContextPlugin::color(QString cor)
{
    Color color;
    color.color(cor);
}
