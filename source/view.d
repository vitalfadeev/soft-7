module view;

import std.algorithm;
import std.range;
import std.conv;
import std.format;
import std.stdio;
import std.traits;
import bindbc.sdl;
import game;
import cls.o;
import types;
import wrappers;


struct View
{
    Game*     game;
    Window*   window;
    Renderer* renderer;

    this( Game* game )
    {
        this.game = game;

        // Init
        MaSDL();
        RegisterCustomEvents();
     
        // Window, Surface
        MaWindow();

        // Renderer
        MaRenderer();
    }


    //
    void MaSDL()
    {
        SDLSupport ret = loadSDL();

        if ( ret != sdlSupport ) 
        {
            if ( ret == SDLSupport.noLibrary ) 
                throw new Exception( "The SDL shared library failed to load" );
            else if ( SDLSupport.badLibrary ) 
                throw new Exception( "One or more symbols failed to load. The likely cause is that the shared library is for a lower version than bindbc-sdl was configured to load (via SDL_204, GLFW_2010 etc.)" );
        }

        loadSDL( "sdl2.dll" );
    }


    //
    void RegisterCustomEvents()
    {
        import std.traits;
        import std.string;
        import types;
        static foreach( m; __traits(allMembers, types) )
            static if ( m.startsWith( "XSDL_") )
                static if ( is( typeof( __traits( getMember, types, m ) ) == XSDL_TYPE ) )
                    RegisterCustomEvent!(__traits( getMember, types, m ))();
    }

    //
    void MaWindow()
    {
        // Window
        window = 
            SDL_CreateWindow(
                "SDL2 Window",
                SDL_WINDOWPOS_CENTERED,
                SDL_WINDOWPOS_CENTERED,
                640, 480,
                0
            );

        if ( !window )
            throw new SDLException( "Failed to create window" );

        // Surface
        SDL_Surface* surface = SDL_GetWindowSurface( window );
        import std.string : fromStringz;
        import std.format;
        if ( SDL_GetError()[0] )
            throw new SDLException( format!"error: SDL_GetWindowSurface(): %s"( fromStringz( SDL_GetError() ) ) );

        // Update
        SDL_UpdateWindowSurface( window );

        if ( SDL_GetError()[0] )
            throw new SDLException( format!"error: SDL_GetWindowSurface(): %s"( fromStringz( SDL_GetError() ) ) );
    }


    //
    void MaRenderer()
    {
        renderer = SDL_CreateRenderer( window, -1, SDL_RENDERER_SOFTWARE );
        if ( renderer is null )
            throw new SDLException( "SDL_CreateRenderer" );
    }


    Size ViewSize()
    {
        return PXSize( 640, 480 );
    }


    void Draw()
    {
        Size size = ViewSize();
        cls.o.Draw( game.c, renderer, size ); // wrappers.Draw
        SDL_RenderPresent( renderer );
    }
}


//
class SDLException : Exception
{
    this( string msg )
    {
        super( format!"%s: %s"( SDL_GetError().to!string, msg ) );
    }
}


void RegisterCustomEvent(alias T)()
{
    T = SDL_RegisterEvents(1);
    if ( T == ((Uint32.min)-1) ) 
        throw new SDLException( __FUNCTION__ );
}
