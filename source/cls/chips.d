module cls.chips;

import std.stdio;
import bindbc.sdl;
import cls.o;
import colors;
import types;


struct Chips
{
    // Sensor
    // Draw from O
    // Load from state
    mixin OMixin!O;

    string fileName = "xxx.sav";

    static
    void Load( O* o )
    {
        import cls : Ma;

        //auto chip1 = Ma( "Chip" );
        //chip1.rect = GridRect( 1, 1, 5, 2 );
        //chip1.dragable = true;
        //chip1.selectable = true;
        //chip1.hoverable = true;
        //Eat( chip1, cast(O*)new ChipOut() );
        //with (chip1.reo) { w = 1; h = 1; hoverable = true; }
        //Eat( chip1, cast(O*)new ChipOut() );
        //with (chip1.reo) { w = 1; h = 1; hoverable = true; }
        //Eat( chip1, cast(O*)new ChipOut() );
        //with (chip1.reo) { w = 1; h = 1; hoverable = true; }
        //Arrange( cast(O*)chip1 );
        //Eat( o, cast(O*)chip1 );

        //auto chip2 = Ma( "Chip" );
        //chip2.rect = GridRect( 1, 5, 5, 2 );
        //chip2.dragable = true;
        //chip2.selectable = true;
        //chip2.hoverable = true;
        //Eat( chip2, cast(O*)new ChipOut() );
        //with (chip2.reo) { w = 1; h = 1; hoverable = true; }
        //Eat( chip2, cast(O*)new ChipOut() );
        //with (chip2.reo) { w = 1; h = 1; hoverable = true; }
        //Eat( chip2, cast(O*)new ChipOut() );
        //with (chip2.reo) { w = 1; h = 1; hoverable = true; }
        //Arrange( cast(O*)chip2 );
        //Eat( o, cast(O*)chip2 );

        //auto spiro = Ma( "Spiro" );
        //spiro.rect = GridRect( 7, 3, 5, 2 );
        //spiro.dragable = true;
        //spiro.selectable = true;
        //spiro.hoverable = true;
        //Arrange( cast(O*)spiro );
        //Eat( o, cast(O*)spiro );

        //auto drawer = Ma( "Drawer" );
        //drawer.size = GridSize( 5, 2 );
        //Eat( o, cast(O*)drawer );
    }
}
