module cls.o.drags;

import std.stdio;
import bindbc.sdl;
import cls.o;
import colors : Pal, SDL_SetRenderDrawColorStruct;
import cls.o.inits;
import cls.o.hovers;
import types;
import wrappers;


struct Drag
{
    mixin StateMixin;
    

    Color fg = Pal.Drag;
    Color bg = Pal.Black;


    static
    void Draw( O* o, Renderer* renderer, Size drawSize )
    {
        Init._DrawBackground( o, renderer );
        Init._DrawGrid( o, renderer );
        _DrawLines( o, renderer );

        // recursive
        DrawRecursive( o, renderer, drawRect );
    }


    static
    void _DrawLines( O* o, Renderer* renderer )
    {
        auto x = o.x;
        auto y = o.y;
        auto w = o.w;
        auto h = o.h;

        auto x1 = x * gridsize;
        auto y1 = y * gridsize;
        auto x2 = (x+w) * gridsize;
        auto y2 = (y+h) * gridsize;

        SDL_SetRenderDrawColorStruct( renderer, Pal.Drag );
        SDL_RenderDrawLine( renderer, x1, y1, x2, y2 ); // \
        SDL_RenderDrawLine( renderer, x1, y2, x2, y1 ); // /
    }


    static
    void on_SDL_MOUSEMOTION( O* o, D* d )
    {

        if ( d.motion.state & SDL_BUTTON_LMASK )
        {
            auto mousePoint = GridPoint( d.motion.x, d.motion.y, gridsize );
            o.point = mousePoint - o.clickRel;
            .Arrange( o );
        }
    }


    static
    void to_Hover( O* o, D* d )
    {
        if ( d.type == SDL_MOUSEBUTTONUP ) 
        if ( d.button.button & SDL_BUTTON_LMASK ) 
        {
            Go!Hover( o );
            SendDrop( o );
        }
    }
}
