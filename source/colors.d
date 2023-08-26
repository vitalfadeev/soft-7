module colors;

import bindbc.sdl;
import types;


enum Pal : Color
{
    Black  =   Color(   0,   0,   0, SDL_ALPHA_OPAQUE ),
    Grey   =   Color(  60,  60,  60, SDL_ALPHA_OPAQUE ),
    Normal =   Color( 199, 199, 199, SDL_ALPHA_OPAQUE ),
    Selected = Color(  99, 199,  99, SDL_ALPHA_OPAQUE ),
    Hovered =  Color(  99,  99,  99, SDL_ALPHA_OPAQUE ),
    Drag =     Color( 199,  99,  99, SDL_ALPHA_OPAQUE ),
    Drop =     Color( 199, 199,  99, SDL_ALPHA_OPAQUE ),
    Grid =     Color(  55,  55,  55, SDL_ALPHA_OPAQUE ),
};

auto SDL_SetRenderDrawColorStruct(TR)( TR renderer, Pal color )
{
    SDL_SetRenderDrawColor( renderer, color.r, color.g, color.b, color.a );
}
auto SDL_SetRenderDrawColorStruct(TR)( TR renderer, Color color )
{
    SDL_SetRenderDrawColor( renderer, color.r, color.g, color.b, color.a );
}
