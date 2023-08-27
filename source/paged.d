module paged;

import std.stdio : writeln;

// Paged storage
//   for minimize memory allocation
//   and remove re-allocations
struct Paged(T)
{
    Page* first;
    Page* last;

    struct Page
    {
        ubyte    l;
        T[l.max] a;
        Page*  next;
    }

    void opOpAssign( string op : "~" )( T b )
    {
        Add( b );
    }

    void Add( T b )
    {
        // 1st element
        if ( last is null )
        {
            last = new Page();
            first = last;
        }

        // 2,3,... element
        //   next page
        if ( last.l == last.l.max )
        {
            auto p = new Page();
            last.next = p;
            last = p;
        }

        // put value
        last.a[ last.l ] = b;
        last.l++;
    }

    // foreach ( a; p )
    int opApply(scope int delegate( ref T ) dg)
    {
        auto p = first;
        while ( p !is null )
        {
            for ( auto i = 0; i < p.l; i++ )
            {
                int result = dg( p.a[i] );
                if (result)
                    return result;
            }

            //
            p = p.next;
        }
        return 0;
    }    
}

unittest
{
    Paged!int p;
    p ~= 1;
    p ~= 2;
    p ~= 3;
    assert( p.first == p.last );
    assert( p.last.l == 3 );
    assert( p.last.a[0] == 1 );
    assert( p.last.a[1] == 2 );
    assert( p.last.a[2] == 3 );

    for ( auto i=0; i<256; i++ )
    {
        p ~= i;
    }
    assert( p.first != p.last );
    assert( p.first.next == p.last );
    assert( p.last.a[3] == 255 );
    assert( p.last.l == 4 );
}
