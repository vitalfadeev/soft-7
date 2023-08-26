## tpls

            fast-add  fast-del-back  fast-del-in  fast-del-first  find
a[]         ++        +++            -            -               -
   
struct Rec
  a 
  a* next   +         -              -            ++              -

struct Rec
  a 
  a* next
  a* prev   +         +              +            +               -

struct
  a
  hash
  a* left
  a* right  -         -              -            -               +

sorted[]    -         +              -            +               +
