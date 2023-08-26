module wrappers;

import std.stdio;
import bindbc.sdl;
import cls.o;
import types;


void SendSlow( O* o )
{
    Send( o, XSDL_SLOW );
}

void SendDrag( O* o )
{
    Send( o, XSDL_DRAG );
}

void SendDrop( O* o )
{
    Send( o, XSDL_DROP );
}

void XSave(T : O)( T* o )
{
    ubyte[] result;
    Save( cast(O*)o, 1, &result );
    import std.file;
    write( "xxx.sav", result );
}

void XLoad()
{
    import std.file;

    auto result = cast(ubyte[])read( "xxx.sav" );

    foreach (c; result)
    {
        if ( c == 'o' ) {}
        if ( c == 's' ) {}
        if ( c == 'a' ) {}
        if ( c == 'r' ) {}
    }
}

