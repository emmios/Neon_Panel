#ifndef TELA_H
#define TELA_H


#include <QObject>
#include <QDebug>
#include <QDir>
#include <QFileInfoList>

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>


class Tela
{
public:
    Tela();
    int getDesktopsCount();
    void displayChange(int num);
};

#endif // TELA_H
