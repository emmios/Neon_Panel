#ifndef WINDOW_H
#define WINDOW_H

#include <QWindow>
#include <QObject>
#include <QString>

class SignalOver : public QObject
{
    Q_OBJECT

public slots:
    void addWindow(QString arg);
    void createWindow(QString arg);

signals:
    void onAddWindow(QString arg);
    void onCreate(QString arg);
    void onDestroy();
    void onRemoveAllWindows();
    void onClearWindows();
    void onActiveWindow();
    void onRemoveTryIcon(int arg);
    void onNotifications(int arg);
    void onAddTryIcon(QString arg);
};

#endif // WINDOW_H
