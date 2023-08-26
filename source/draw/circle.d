module draw.circle;

import bindbc.sdl;
import types;
import std.stdio : writeln;


version ( X86 )
void Circle( Renderer* renderer, int cx, int cy, int r )
{
    pragma( msg, __FUNCTION__, "X86" );
    int x;
    int y = r;
    int delta = 1 - 2 * r;
    int error = 0;

    while ( y >= x )
    {
        Drawpixel( renderer, cx + x, cy + y );
        Drawpixel( renderer, cx + x, cy - y );
        Drawpixel( renderer, cx - x, cy + y );
        Drawpixel( renderer, cx - x, cy - y );
        Drawpixel( renderer, cx + y, cy + x );
        Drawpixel( renderer, cx + y, cy - x );
        Drawpixel( renderer, cx - y, cy + x );
        Drawpixel( renderer, cx - y, cy - x );

        error = 2 * (delta + y) - 1;

        if ( (delta < 0) && (error <= 0) )
        {
            x++;
            delta += (2 * x + 1);
            continue;
        }

        if ( (delta > 0) && (error > 0) )
        {
            y--;
            delta -= (2 * y + 1);
            continue;
        }

        x++;
        y--;
        delta += (2 * (x - y));
    }
}
/*
void CircleBz( Renderer* renderer, int cx, int cy, int r )
{
    //  3 | 2
    // ---+---
    //  4 | 1
    import std.math;
    import std.conv;

    int x = 0;
    int y = r;

    int rr = r*r;
    int xx = x*x;
    int yy = y*y;

L0: // X=R Y=0
    Drawpixel( renderer, cx + x, cy + y );

L1: // 0 < Y < X <= R
    while ( x > y )
    {
        Drawpixel( renderer, cx + x, cy + y );

        y++;
        yy = y*y;
        while ( xx + yy > rr )
        {
            x--;
            xx = xx*xx;
        }
    }

L2: // X = Y
    Drawpixel( renderer, cx + x, cy + y );

L3: // 0 < X < Y
    while ( x > 0 )
    {
        Drawpixel( renderer, cx + x, cy + y );

        x--;
        xx = x*x;
        while ( xx + yy > rr )
        {
            y--;
            y = yy*yy;
        }
    }
}
*/

pragma( inline, true )
void Drawpixel( Renderer* renderer, int x, int y )
{
    SDL_RenderDrawPoint( renderer, x , y );
}


// Software Version
version ( X86_64 )
version ( NO_SIMD )
void Circle( Renderer* renderer, int cx, int cy, int r )
{  
    pragma( msg, __FUNCTION__, "X86_64" );
    import std.conv;
    import std.math : PI;
    import std.math : cos, sin;

    // L = 2 PI R
    // L iterations
    // Rotate to angle = 2 PI / L
    // L rotations
    alias T = real;
    T R = cast(T)r;
    T L = 2 * PI * R;
    T angle = 2 * PI / L; // 1 / R
    T c = cos( angle );
    T s = sin( angle );

    auto A = Point!T( R, 0 );

    // Rotate CW
    // A x,y
    // AB = l
    // B = A + A.norm * l * angle
    auto AR = Point!T( 1, 0 );

    for ( int i=0; i < L; i++ )
    {
        Drawpixel!T( renderer, cx, cy, A );

        AR = AR.Rotate( angle ); // SIMD 
        A = AR * R;              //
    }
}

// SIMD Optimized x86_64 D Version 
version ( X86_64 )
version ( D_SIMD )
void Circle( Renderer* renderer, int cx, int cy, int r )
{  
    pragma( msg, __FUNCTION__, "X86_64,SIMD" );
    import core.simd;

    // radius
    float R = r;

    // iterations
    int L = 2 * PI * R;

    // angle
    float angle = 1 / R;

    // cos, sin
    import std.math : cos, sin;
    float c = cos( angle );
    float s = sin( angle );

    // start Point
    float4 A;
    A.array[0] = R; // x
    A.array[1] = 0; // y
    A.array[2] = R; // x
    A.array[3] = 0; // y

    // multiplier
    // x * c - y * s; 
    // x * s + y * c;
    float4 M;
    M.array[0] = c;
    M.array[1] = s * -1;
    M.array[2] = s;
    M.array[3] = c;

    float4 C;
    M.array[0] = cx;
    M.array[1] = cy;

    float4 CenteredA;

    // raster coords
    import std.math : round;
    import std.conv : to;
    int x;
    int y;

    while ( L > 0 )
    {
        // center
        CenteredA = A + C;
        x = CenteredA.array[0].round().to!int;
        y = CenteredA.array[1].round().to!int;
        SDL_RenderDrawPoint( renderer, x, y );

        // SIMD rotate
        A *= M;

        L--;
    }
}


// SIMD Optimized x86_64 LDC Version 
version = LDC_SIMD;
version ( X86_64 )
version ( LDC )
version ( LDC_SIMD )
void Circle( Renderer* renderer, int cx, int cy, int r )
{  
    pragma( msg, __FUNCTION__, "X86_64,LDC,SIMD" );
    import std.math : PI, cos, sin, round;
    import std.conv;
    import inteli;
    //import ldc.llvmasm : __asm;

    // StartPoint(R,0) x = R, y = 0
    // A( x, y, x, y )
    // a = 1 / R
    // c = cos a
    // s = sin a
    // M ( c, -s, s, c )
    // C( cx, cy )
    //
    // for ...
    //   A = A * M // rotate
    //   P = A
    //   P = P * R // scale
    //   P = P + C // center
    //   Draw P

    //
    // PS.
    // dot-product (a, b)   = sin (a,b) = float
    // cross-product (a, b) = cos (a,b) = float

    auto R = cast(float)r;

    float4 A;
    A.ptr[0] = R;
    A.ptr[1] = 0;
    A.ptr[2] = R;
    A.ptr[3] = 0;

    float a = 1.0f/R;
    float c = cos( a );
    float s = sin( a );

    float4 M;
    M.ptr[0] =  c;
    M.ptr[1] = -s;
    M.ptr[2] =  s;
    M.ptr[3] =  c;

    float4 C;
    C.ptr[0] = cx;
    C.ptr[1] = cy;
    C.ptr[2] = cx;
    C.ptr[3] = cy;

    float4 P;
    float[4] p;

    // iterations
    int L = (2 * PI * r).round.to!int;

    while ( L > 0 )
    {
                                        // A = A * M // rotate
        A = _mm_mul_ps   ( A, M );      //   x*c y*s x*-s y*c
        A = _mm_hadd_ps  ( A, A );      //      +        +  
        A = _mm_movelh_ps( A, A );      // . . x y => x y x y 
        P = _mm_move_ss  ( A, A );      // P = A
        P = _mm_add_ps   ( P, C );      // P = P + C // center
            _mm_store_ps ( p.ptr, P );  // p = P

        import draw.point;
        draw.point.Point( renderer, p[0].round.to!int, p[1].round.to!int );

        //
        L--;
    }
}


pragma( inline, true )
static void Drawpixel(T)( Renderer* renderer, int cx, int cy, Point!T A )
{
    SDL_RenderDrawPoint( renderer, cx+A.intx, cy+A.inty );
}


struct Point(T)
{
    T x;
    T y;

    Point!T Normal()
    {
        return Point!T( -y, x );
    }

    T L()
    {
        import std.math : sqrt, pow;
        return sqrt( pow(x,2) + pow(y,2) );
    }

    Point!T opBinary( string op : "+" )( Point!T b )
    {
        return Point!T( x + b.x, y + b.y );
    }

    Point!T opBinary( string op : "-" )( Point!T b )
    {
        return Point!T( x - b.x, y - b.y );
    }

    Point!T opBinary( string op : "*" )( T l )
    {
        return Point!T( x * l, y * l );
    }

    Point!T opBinary( string op : "/" )( T l )
    {
        return Point!T( x / l, y / l );
    }

    // r = ox2 cos α + oy2 sin α
    Point!T Rotate( T angle )
    {
        import std.math : cos, sin;

        T c = cos( angle );
        T s = sin( angle );

        return 
            Point!T( 
                x * c - y * s,  x * s + y * c
            );
    }

    Point!T Normalize()
    {
        T l = L();
        return Point!T( x / l, y / l );
    }

    TX x_to(TX)()
    {
        import std.math : round;
        import std.conv : to;
        return x.round().to!TX;
    }

    TY y_to(TY)()
    {
        import std.math : round;
        import std.conv : to;
        return y.round().to!TY;
    }

    int intx()
    {
        return x_to!int;
    }

    int inty()
    {
        return y_to!int;
    }
}
