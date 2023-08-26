module draw.grid;

import bindbc.sdl;
import types;


void Grid( Renderer* renderer, Size size )
{
    import std.range : iota;

    SDL_Rect r = PXRect( size ).Center().ToSDLMetrix();

    foreach( _y; iota( 0, r.h, gridsize ) )
        SDL_RenderDrawLine( renderer, 0, _y, r.w, _y ); // -

    foreach( _x; iota( 0, r.w, gridsize ) )
        SDL_RenderDrawLine( renderer, _x, 0, _x, r.h ); // |
}
