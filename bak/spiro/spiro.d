module cls.spiro.spiro;

import bindbc.sdl;
import cls.o;
import colors : Pal, SDL_SetRenderDrawColorStruct;
import types;
import wrappers;
import std.stdio : writeln;
import draw.circle;

struct Spiro
{
    mixin OMixin!O;

    static
    void Draw( O* o, Renderer* renderer, Size drawSize )
    {
        O.Init._DrawBackground( o, renderer );
        _DrawSpiro( o, renderer );

        // recursive
        DrawRecursive( o, renderer, drawRect );
    }


    static
    void _DrawSpiro( O* o, Renderer* renderer )
    {
        auto x = o.x;
        auto y = o.y;
        auto w = o.w;
        auto h = o.h;

        auto x1 = x * gridsize;
        auto y1 = y * gridsize;
        auto x2 = (x+w) * gridsize;
        auto y2 = (y+h) * gridsize;

        int cx = x1 + (x2-x1)/2;
        int cy = y1 + (y2-y1)/2;
        int r = 50;

        SDL_SetRenderDrawColorStruct( renderer, o.fg );
        Circle( renderer, cx, cy, r );
    }
}


