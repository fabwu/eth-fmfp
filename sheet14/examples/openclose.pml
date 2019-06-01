short o;

#define isOpen (o==1)
#define isClosed (o==0)

#define open  o = o + 1
#define close o = o - 1

init {
  open;
  do
  :: close; open
  :: break
  od;
  open;
  printf("Status: %d\n", o);
}

ltl { !([](isOpen||isClosed)) }

