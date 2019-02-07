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
               //pixel = ctx->xwindowTrayIcon(QString(id.split(";")[0]).toInt());
               pixel = ctx->xwindowTrayIcon((Window)QString(id.split(";")[0]).toInt());
           }

           if (pixel.isNull())
           {
               QString icon;
               QImage img;
               icon = ctx->defaultIconApplications;

               if (icon.isEmpty())
               {
                  img.load(ctx->basepath + "/default.svg");
                  //pixel.load(ctx->basepath + "/default.svg");
               }
               else
               {
                  img.load(icon);
                  //pixel.load(icon);
               }

               img = img.scaled(QSize(24, 24), Qt::KeepAspectRatio, Qt::SmoothTransformation);
               pixel.fromImage(img);
               //pixel = pixel.scaled(16, 16, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);
           }
       }

       //pixel.save("/home/shenoisz/Documents/" + id.split(";")[0] + ".png");
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
           //QRect rect(0, 0, screen->geometry().width(), screen->geometry().height() - 40);
           QRect rect(0, 0, screen->geometry().width(), screen->geometry().height());
           pixel = pixel.copy(rect);
       }

       return pixel;
    }
};

#endif // QQUICKIMAGE_H
