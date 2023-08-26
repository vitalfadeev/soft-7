module draw.rect;

import bindbc.sdl;
import types;


void Rect( Renderer* renderer, int x, int y, int w, int h )
{
    SDL_Rect r = { x, y, w, h };
    SDL_RenderDrawRect( renderer, &r );
}

// at center
void FillRect( Renderer* renderer, Size size )
{
    // Native metrix ( 0, 0 - at center )
    // to SDL metrix ( 0, 0 - at top left corner )
    SDL_Rect rsdl = PXRect( size ).Center().ToSDLMetrix();
    SDL_RenderFillRect( renderer, &rsdl );
}

void Rect( Renderer* renderer, types.Rect* r )
{
    SDL_Rect rsdl = r.Center().ToSDLMetrix();
    SDL_RenderDrawRect( renderer, &rsdl );
}
