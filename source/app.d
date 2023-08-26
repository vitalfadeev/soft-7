import std.stdio;

void main()
{
	import game;
	import types;
	import cls.o;
	import cls.chips;

	auto c = new Chips(); // central object
	c.size = GridSize( 12, 10 );
	new Game( cast(O*)c ).Go();
}
