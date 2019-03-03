#ifndef QQUICKIMAGE_H
#define QQUICKIMAGE_H

#include <QQuickImageProvider>
#include <QDebug>

#include "context.h"


class QQuickImage : public QQuickImageProvider
{
public:
    QQuickImage() : QQuickImageProvider(QQuickImageProvider::Pixmap)
    {

    }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
       QPixmap pixel;

       if (!id.isEmpty())
       {
           QString wclass = id.split(";")[1];
           if (wclass.isEmpty()) wclass = id.split(";")[2];
           pixel = ctx->getIconByClass(id.split(";")[0], wclass);

           if (pixel.isNull())
           {
               pixel = ctx->xwindowTrayIcon((Window)QString(id.split(";")[0]).toInt());
           }

           if (pixel.isNull())
           {
               QString icon = ctx->defaultIconApplications;

               if (icon.isEmpty())
               {
                  pixel.load("/opt/synth_panel/default.svg");
                  pixel.scaled(QSize(24, 24), Qt::KeepAspectRatio, Qt::SmoothTransformation);
               }
               else
               {
                  pixel.load(icon);
                  pixel.scaled(QSize(24, 24), Qt::KeepAspectRatio, Qt::SmoothTransformation);
               }
           }
       }

       return pixel;
    }

    Context *ctx;
};


class QQuickImg : public QQuickImageProvider
{
public:
    QQuickImg() : QQuickImageProvider(QQuickImageProvider::Pixmap) { }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
       QScreen *screen = QGuiApplication::primaryScreen();
       QPixmap pixel = screen->grabWindow(0);

       if (id == "crop")
       {
           QRect rect(0, 0, screen->geometry().width(), screen->geometry().height() - 40);
           //QRect rect(0, 0, screen->geometry().width(), screen->geometry().height());
           pixel = pixel.copy(rect);
       }

       return pixel;
    }
};

#endif // QQUICKIMAGE_H
