module cls.drawer;

import std : DList;
import bindbc.sdl;
import cls.o;
import types;
import geom;


struct Drawer
{
    mixin OMixin!(O,Init);

    DList!DrawOp dops;
    PreviewPoint pre;

    //static
    //void Draw( O* o, Renderer* renderer, Size drawSize )
    //{
    //    auto pre = cast(O*)&(cast(Drawer*)o).pre;
    //    PreviewPoint.Draw( o, renderer, drawRect );
    //    _DrawDops( cast(Drawer*)o, renderer, drawRect );
    //}

    struct Init
    {
        mixin StateMixin;

        static
        void on_XSDL_OVER_MOUSE( O* o, D* d )
        {
            // preview start point
            (cast(Drawer*)o).pre.point = GridPoint( d.motion.x, d.motion.y, gridsize );
        }
        
        static
        void on_SDL_MOUSEMOTION( O* o, D* d )
        {
            // preview start point
            (cast(Drawer*)o).pre.point = GridPoint( d.motion.x, d.motion.y, gridsize );
        }

        static
        void Draw( O* o, Renderer* renderer, Size drawSize )
        {
            cls.o.Init.Draw( o, renderer, drawRect );
            PreviewPoint.Draw( cast(O*)( &((cast(Drawer*)o).pre) ), renderer, drawRect );
        }

        static
        void to_StartPoint( O* o, D* d )
        {
            auto button = d.button;

            if ( d.type == SDL_MOUSEBUTTONDOWN )
            if ( button.button & SDL_BUTTON_LMASK ) 
            {
                auto mousePoint = GridPoint( d.motion.x, d.motion.y, gridsize );
                o.clickRel = mousePoint - o.point;
                if ( o.selectable )
                    Go!StartPoint( o );
            }
        }
    }

    struct StartPoint
    {
        mixin StateMixin;

        static
        void Draw( O* o, Renderer* renderer, Size drawSize )
        {
            //
        }

    }

    struct EndPoint
    {
        mixin StateMixin;

        static
        void Draw( O* o, Renderer* renderer, Size drawSize )
        {
            //
        }

    }
}

struct PreviewPoint
{
    mixin OMixin;

    static
    void Draw( O* o, Renderer* renderer, Size drawSize )
    {
        import draw.circle;
        int cx = o.x + o.w/2;
        int cy = o.y + o.h/2;
        int r  = 5;
        Circle( renderer, cx, cy, r );
    }    
}


void _DrawDops( Drawer* o, Renderer* renderer, Size drawSize )
{
    foreach( ref dop; o.dops )
    {
        switch ( dop.type )
        {
            case DTYPE.POINT : dop.p.Draw( renderer, drawRect ); break;
            case DTYPE.LINE  : dop.l.Draw( renderer, drawRect ); break;
            case DTYPE.RECT  : dop.r.Draw( renderer, drawRect ); break;
            case DTYPE.CIRCLE: dop.c.Draw( renderer, drawRect ); break;
            case DTYPE.ARC   : dop.a.Draw( renderer, drawRect ); break;
            default: 
        }
    }
}


enum DTYPE
{
    POINT,
    LINE,
    RECT,
    CIRCLE,
    ARC,
}

union DrawOp
{
    DTYPE      type;
    PointDraw  p;
    LineDraw   l;
    RectDraw   r;
    CircleDraw c;
    ArcDraw    a;
}

struct PointDraw
{
    DTYPE type;
    Point p;

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.point : Point;
        SDL_SetRenderDrawColor( renderer, 55, 55, 55, SDL_ALPHA_OPAQUE );
        Point( renderer, p.x , p.y );
    }
}

struct LineDraw
{
    DTYPE type;
    Point p1;
    Point p2;

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.line : Line;
        SDL_SetRenderDrawColor( renderer, 55, 55, 55, SDL_ALPHA_OPAQUE );
        Line( renderer, p1.x, p1.y, p2.x, p2.y );
    }
}

struct RectDraw
{
    DTYPE type;
    Point p1;
    Point p2;

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.rect : Rect;
        SDL_Rect r = { p1.x, p1.y, p2.x-p1.x, p2.y-p1.y};

        SDL_SetRenderDrawColor( renderer, 55, 55, 55, SDL_ALPHA_OPAQUE );
        Rect( renderer, &r );
    }
}

struct CircleDraw
{
    DTYPE type;
    Point p;
    Coord r;

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.circle : Circle;
        Circle( renderer, p.x, p.y, r );
    }
}

struct Circle2pDraw
{
    DTYPE type;
    Point p;
    Point c;

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.circle : Circle;

        Coord r = Line( p, c ).len();
        Circle( renderer, p.x, p.y, r );
    }
}

struct Circle3pDraw
{
    DTYPE type;
    Point p1;
    Point p2;
    Point p3;

    void Draw( Renderer* renderer, Size drawSize )
    {
        //
    }
}

struct ArcDraw
{
    DTYPE type;
    Point p1; // start point
    Point p2; // end point
    Point c;  // center

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.arc : Arc;
        //Arc( renderer, cx, cy, x1, y1, x2, y2 );
    }
}

struct ArcP3Draw
{
    DTYPE type;
    Point p1; // start point
    Point p2; // middle point
    Point p3; // end point

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.arc : Arc;
    }
}

struct ArcRDraw
{
    DTYPE type;
    Point p1; // start point
    Point p2; // end point
    Coord r;  // radius

    void Draw( Renderer* renderer, Size drawSize )
    {
        import draw.arc : Arc;
    }
}


