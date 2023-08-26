module types;

import std.traits;
import std.conv;
import bindbc.sdl;
public import px;

alias m    = void;
alias m8   = ubyte;
alias m8s  = ubyte[];
alias m32  = uint;
alias mptr = m*;
alias Timestamp = ReturnType!SDL_GetTicks;
Coord gridsize = 48;

//alias Px        = typeof(SDL_Rect.x); // -32768.65536 .. 0 .. +32768.65536 - 16.16-bit
struct Size
{
    PX w;
    PX h;

    Rect ToRect()
    {
        return Rect( PX(0), PX(0), w, h );
    }

    SDL_Rect ToSDLRect()
    {
        return SDL_Rect( 0, 0, w.h, h.h );
    }
}
Size PXSize( ushort w, ushort h )
{
    return Size( PX( w, 0 ), PX( h, 0 ) );
}

Size GridSize( PX w, PX h )
{
    return Size( PX(w.h * gridsize), PX(h.h * gridsize) );
}
Size GridSize( int w, int h )
{
    return Size( PX(w * gridsize), PX(h * gridsize) );
}

alias Coord     = typeof(SDL_Rect.x);
alias GridCoord = typeof(SDL_Rect.x);
//alias Point     = SDL_Point;
//alias Rect      = SDL_Rect;
alias Renderer  = SDL_Renderer;
alias Window    = SDL_Window;
alias D         = SDL_Event;
alias Color     = SDL_Color;

struct Point
{
    PX x;
    PX y;

    SDL_Point ToSDLPoint()
    {
        return SDL_Point( x.h, y.h );
    }
}

struct Rect
{
    PX x;
    PX y;
    PX w;
    PX h;

    Rect Center()
    {
        return 
            Rect(
                PX(-w.h / 2),
                PX(-h.h / 2),
                w,
                h
            );
    }

    SDL_Rect ToSDLMetrix()
    {
        return SDL_Rect( x.h, y.h, w.h, h.h );
    }

    SDL_Rect ToSDLRect()
    {
        return SDL_Rect( x.h, y.h, w.h, h.h );
    }
}
Rect PXRect( Size size )
{
    return Rect( PX(0), PX(0), size.w, size.h );
}


struct GridPoint
{
    GridCoord x,y;

    this( Coord x, Coord y )
    {
        this.x = x;
        this.y = y;
    }

    this(T)( Coord x, Coord y, T gridsize )
    {
        this.x = x / gridsize;
        this.y = y / gridsize;
    }


    GridPoint opBinary( string op : "+" )( GridPoint b )
    {
        return GridPoint( x + b.x, y + b.y );
    }

    GridPoint opBinary( string op : "-" )( GridPoint b )
    {
        return GridPoint( x - b.x, y - b.y );
    }
}

struct GridRect
{
    GridCoord x,y,w,h;
}


bool PointInRect( Point p, Rect r )
{
    auto psdl = p.ToSDLPoint();
    auto rsdl = r.ToSDLRect();
    return 
        SDL_PointInRect( &psdl, &rsdl ) == SDL_TRUE ?
            true : 
            false;
}

auto IntersectRect( GridRect* a, GridRect* b, GridRect* result )
{
    return SDL_IntersectRect( cast(SDL_Rect*)a, cast(SDL_Rect*)b, cast(SDL_Rect*)result );
}

bool RectInRect( GridRect* a, GridRect* b )
{
    SDL_Rect result;
    if ( SDL_IntersectRect( cast(SDL_Rect*)a, cast(SDL_Rect*)b, &result ) == SDL_TRUE )
        return true;
    else
        return false;
}

alias XSDL_TYPE = Uint32;
XSDL_TYPE XSDL_IN_MOUSE;
XSDL_TYPE XSDL_OUT_MOUSE;
XSDL_TYPE XSDL_OVER_MOUSE;
XSDL_TYPE XSDL_DRAG;
XSDL_TYPE XSDL_DROP;
XSDL_TYPE XSDL_SLOW;

string XSDL_toString( XSDL_TYPE a )
{
    import std.traits;
    import std.string;
    import types;
    static foreach( m; __traits(allMembers, types) )
        static if ( m.startsWith( "XSDL_") )
            static if ( is( typeof( __traits( getMember, types, m ) ) == XSDL_TYPE ) )
                if ( a == __traits( getMember, types, m ) ) return m;

    return a.to!string;
}

// arrange struct
struct Ars
{
    GridRect   rect;
    GridCoord  totalw;
    ARRANGATOR arrangator;
}

alias ARRANGATOR = GridPoint function( Ars* ar, Align ali, GridRect* r );

enum Align
{
    Left,
    Middle,
    Right
}
