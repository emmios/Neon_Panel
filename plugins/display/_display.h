#ifndef DISPLAY_H
#define DISPLAY_H


#include <QObject>
#include <QDebug>
#include "src/xlibutil.h"


class _Display
{
public:
    _Display();
    int getDesktopsCount();
};

#endif // DISPLAY_H
