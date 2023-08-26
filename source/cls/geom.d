module geom;

import std.math;
import std.conv;
import types;


auto pow(T)( T a )
{
    return a*a;
}
auto sqrt(T)( T a )
{
    return std.math.sqrt( cast(float)a ).to!Coord;
}


//struct Point
//{
//    Coord x;
//    Coord y;
//}

struct Line
{
    Point a;
    Point b;

    auto len()
    {
        return sqrt( pow(b.x - a.x) + pow(b.y - a.y) );
    }
}

unittest
{
    Point a;
    Point b;

    auto l = b - a;
}

