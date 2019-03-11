#include "power.h"

//systemctl poweroff
//systemctl reboot
//systemctl suspend
//systemctl hibernate
//systemctl hybrid-sleep


Power::Power()
{

}

void Power::shutdown()
{
    sync();
//    reboot(LINUX_REBOOT_CMD_POWER_OFF);
    QProcess *process = new QProcess();
    //process->start("shutdown -h now");
    process->start("systemctl poweroff");
}

void Power::restart()
{
    sync();
    //reboot(LINUX_REBOOT_CMD_RESTART);
    QProcess *process = new QProcess();
    //process->start("reboot");
    //process->start("shutdown -r now");
    process->start("systemctl reboot");
}

void Power::suspend()
{
    sync();
//    reboot(LINUX_REBOOT_CMD_SW_SUSPEND);
    QProcess *process = new QProcess();
    //process->start("pm-suspend");
    process->start("systemctl suspend");
}

void Power::logoff()
{
    sync();
    QString username = qgetenv("USER");
    QProcess *process = new QProcess();
    //QStringList args;
    //args << "-KILL" << "-u" << username;
    process->start("pkill -KILL -u " + username);
}

int Power::hasBattery()
{

    return 0;

    QDir dir("/sys/class/power_supply");

    if(dir.exists())
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

int Power::isPlugged()
{
    //QStringList lista;
    QProcess *process = new QProcess();
    //process.start("upower -i /org/freedesktop/UPower/devices/battery_BAT0");
    //lista << "-i";
    //lista << "/org/freedesktop/UPower/devices/battery_BAT0";
    process->start("upower -i /org/freedesktop/UPower/devices/battery_BAT0");
    QStringList l = QString(process->readAll()).split("\n");
    //qDebug() << l << l.length();
    process->close();

    return 0;
}
