#ifndef WINDOW_H
#define WINDOW_H

#include <QWindow>
#include <QObject>
#include <QString>

class SingnalOver : public QWindow
{
    Q_OBJECT

signals:
    void create();
    void destroy();
    void desktopWindow(QString nome, QString wmclass, int winId);
    void clearWindows();
    void activeWindow();

//public slots:
//    void activeWindow();

};

#endif // WINDOW_H
