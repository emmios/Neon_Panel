#ifndef SYSTHREAD_H
#define SYSTHREAD_H

#include <QThread>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QWindow>
#include <QObject>
#include <QDebug>
#include <QX11Info>
#include <QQuickImageProvider>
#include <QList>
#include <QVariant>
#include <QMetaObject>
#include <QHash>

#include "context.h"
#include "systray.h"


class SysThread : public QThread
{

    Q_OBJECT

public:
    void run();
    QWindow *main;
    Context *ctx;
};

#endif // SYSTHREAD_H
