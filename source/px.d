module px;

struct PX
{
    union
    {
        int a;       // 32
        struct
        {
            short h; // 16
            short l; // 16 
        }
    }
    alias a this;

    this( int a )
    {
        this.a = a;
    }

    this( short h, short l )
    {
        this.h = h;
        this.l = l;
    }

    void opAssign( PX b )
    {
        a = b.a;
    }

    void opAssign( int b )
    {
        a = b;
    }

    void opAssign( short b )
    {
        h = b;
        l = 0;
    }
}

