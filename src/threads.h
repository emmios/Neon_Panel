#ifndef THREADS_H
#define THREADS_H

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
//#include <QMetaObject>
#include <QHash>

#include "context.h"
#include "signalover.h"
#include "systray.h"


class Threads : public QThread
{

    Q_OBJECT

public:
    void run();
    QWindow *main;
    Context *ctx;
};


#endif // THREADS_H
