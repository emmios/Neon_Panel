#include "backgroundconnect.h"


void BackgroundConnect::BgConnect(QString bg)
{
    QMetaObject::invokeMethod(this->main, "blurRefresh",
        Q_ARG(QVariant, bg)
    );
}
