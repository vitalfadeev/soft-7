module draw.point;

import bindbc.sdl;
import types;


void Point( Renderer* renderer, int x, int y )
{
    SDL_RenderDrawPoint( renderer, x, y );
}
