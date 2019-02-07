#ifndef WINDOW_H
#define WINDOW_H

#include <QWindow>
#include <QObject>
#include <QString>

class SignalOver : public QWindow
{
    Q_OBJECT


public slots:
    void addWindow(QString arg);
    void createWindow(QString arg);

signals:
    void createWin(QString arg);
    void create();
    void destroy();
    void removeAllWindows();
    void clearWindows();
    void activeWindow();

//public slots:
//    void activeWindow();

};

#endif // WINDOW_H
