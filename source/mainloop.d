module mainloop;

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


struct MainLoop
{
    Game* game;
    bool  live = true;

    this( Game* game )
    {
        this.game = game;
    }

    void Go()
    {
        while ( live )
        {
            D d;

            // Events & Animations
            auto er = SDL_WaitEventTimeout( &d, 1000 );
            if ( er == 0 && SDL_GetError()[0] == 0 )
            {
                // timeout
                //   do_animations
                //   Render
                //   Rasterize
                DoSlow();
                Draw();
            }
            else
            {
                // event
                //   do_event
                //   if do_event_time > ms_per_frame
                //     do_animations
                //   Rasterize
                Sense( &d );
                Draw();
            }
        }        
    }


    void DoSlow()
    {
        //Slow( cast(O*)game.c );
    }


    void Sense( D* d )
    {
        if ( d.type == SDL_QUIT ) return onQuit( d );
        else
            .Sensor( game.c, d );
    }


    void onQuit( D* d )
    {
        live = false;
    }

    void Draw()
    {
        game.view.Draw();
    }
}
