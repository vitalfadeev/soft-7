module cls.o.hoverselects;

import std.stdio;
import bindbc.sdl;
import cls.o;
import colors : Pal, SDL_SetRenderDrawColorStruct;
import cls.o.inits;
import types;
import wrappers;


struct Hoverselect
{
    mixin StateMixin;


    Color bg = Pal.Hovered;
    Color fg = Pal.Selected;

    static
    void Draw( O* o, Renderer* renderer, Size drawSize )
    {
        Hover._DrawBackground( o, renderer );
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

        SDL_SetRenderDrawColorStruct( renderer, Pal.Selected );
        SDL_RenderDrawLine( renderer, x1, y1, x2, y2 ); // \
        SDL_RenderDrawLine( renderer, x1, y2, x2, y1 ); // /
    }

    static
    void to_Hover( O* o, D* d )
    {
        auto button = d.button;

        if ( d.type == SDL_MOUSEBUTTONDOWN )
        if ( button.button & SDL_BUTTON_LMASK ) 
        if ( o.hoverable )
            Go!Hover( o );
    }


    static
    void to_Init( O* o, D* d )
    {
        auto button = d.button;

        if ( d.type == SDL_MOUSEBUTTONDOWN )
        if ( button.button & SDL_BUTTON_LMASK ) 
        if ( !o.hoverable )
            Go!Init( o );
    }


    static
    void to_Drag( O* o, D* d )
    {
        auto motion   = d.motion;

        if ( d.type == SDL_MOUSEMOTION )
        if ( d.motion.state & SDL_BUTTON_LMASK )
        if ( o.dragable )
        {
            Go!Drag( o );
            SendDrag( o );
        }

        //if ( o.Is( GridPoint( motion.x, motion.y, gridsize ) ) )
        //    Send( o, XSDL_OVER_MOUSE, d );
        //else
        //{
        //    o.ToState!"inits"();
        //    Send( o, XSDL_OUT_MOUSE, d );
        //}
    }
}
