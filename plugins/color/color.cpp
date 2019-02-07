#include "color.h"

Color::Color()
{

}

QString Color::changeDatail(int hue, int light)
{
    QColor color;
    //115
    color = color.fromHsl(hue, 255, light, 255);
    return color.name();
}
