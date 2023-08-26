module cls.o.hovers;

import bindbc.sdl;
import cls.o;
import colors : Pal, SDL_SetRenderDrawColorStruct;
import cls.o.inits;
import types;
import wrappers;


struct Hover
{
    mixin StateMixin;
    
    Color bg = Pal.Hovered;
    Color fg = Pal.Normal;


    static
    void Draw( O* o, Renderer* renderer, Size drawSize )
    {
        _DrawBackground( o, renderer );
        Init._DrawGrid( o, renderer );
        Init._DrawLines( o, renderer );

        // recursive
        DrawRecursive( o, renderer, drawRect );
    }

    static
    void _DrawBackground( O* o, Renderer* renderer )
    {
        auto x = o.x;
        auto y = o.y;
        auto w = o.w;
        auto h = o.h;

        SDL_Rect _rect = { x*gridsize, y*gridsize, w*gridsize, h*gridsize };
        SDL_SetRenderDrawColorStruct( renderer, Pal.Hovered );
        SDL_RenderFillRect( renderer, &_rect );
    }


    static
    void to_Init( O* o, D* d )
    {
        auto motion   = d.motion;

        if ( d.type == SDL_MOUSEMOTION )
        {
            if ( o.Is( GridPoint( motion.x, motion.y, gridsize ) ) )
                Send( o, XSDL_OVER_MOUSE, d );
            else
            {
                Go!Init( o );
                Send( o, XSDL_OUT_MOUSE, d );
            }
        }
    }

    static
    void to_Hoverselect( O* o, D* d )
    {
        auto button = d.button;

        if ( d.type == SDL_MOUSEBUTTONDOWN )
        if ( button.button & SDL_BUTTON_LMASK ) 
        {
            auto mousePoint = GridPoint( d.motion.x, d.motion.y, gridsize );
            o.clickRel = mousePoint - o.point;
            if ( o.selectable )
                Go!Hoverselect( o );
        }
    }
}
