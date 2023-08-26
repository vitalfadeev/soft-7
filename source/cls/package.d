module cls;

public import cls.o;
public import cls.chips;

//static foreach( m; __traits( allMembers, __traits(parent,{}) ) )
    //pragma( msg, m );

//pragma( msg, typeid(O) );

string ClassesMixin()
{
    string s;
    
    s ~= "enum CLASSES\n";
    s ~= "{\n";
    s ~= "   O,\n";
    //s ~= "   Chip,\n";
    //s ~= "   ChipOut,\n";
    s ~= "   Chips,\n";
    //s ~= "   Spiro,\n";
    //s ~= "   Drawer,\n";
    s ~= "};\n";

    return s;
}

string ClassesContentMixin(alias T)()
{
    import std.traits;
    static foreach( m; __traits( allMembers, T ) )
        static if ( __traits( hasMember, __traits( getMember, T, m ), "typeInfo") )
            static if ( __traits( hasMember, __traits( getMember, T, m ), "Sensor") )
                return m;

    //throw new Exception( "undefined class: " ~ T.stringof );
}

// enum CLASSES ...
mixin( ClassesMixin() );

// Chip* o = Factory( "chip.chip" );
O* Ma( string c )
{
    import std.traits;

    static foreach ( en; [EnumMembers!CLASSES] )
        if ( c == ClassNameFromEnum!en ) return cast(O*)( new ClassTypeFromEnum!en );

    throw new Exception( "Unsupported type: " ~ c );
}

template ClassNameFromEnum( CLASSES c )
{ 
    import std.string;
    import std.conv;

    enum ClassNameFromEnum = c.to!string[ lastIndexOf( c.to!string, '.' )+1 .. $ ];
}

template ClassTypeFromEnum( CLASSES c )
{ 
    alias ClassTypeFromEnum = mixin( ClassNameFromEnum!c );
}

template ClassEnumFromType( T )
{
    alias ClassEnumFromType = mixin( "CLASSES." ~ T.stringof );
}
