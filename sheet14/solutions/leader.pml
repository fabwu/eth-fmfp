#define I 3  /* offset for ID assignment */
#define N 5  /* number of processes in the ring */
#define L 1  /* length of a channel */

chan c[N] = [L] of { byte };

init {
  atomic {
    byte i = 1;
    do
    :: i <= N -> run pnode(c[i-1], c[i % N], (N+I-i) % (N+1));
                 i++
    :: else -> break
    od;
  }
}

proctype pnode(chan _in, out; byte id) {
  byte nr;

  out!id;

  do
  :: _in?nr;
     if
     :: nr == id -> /* I am the leader and I know it now */
          printf ("I am process %d with id %d. Leader process has id %d.\n", 
                  _pid, id, nr);
          break
     :: nr > id ->  /* forward id, might be the id of the leader */
          out!nr
     :: else ->     /* forget about the id I received: it is not the leader's id */
          skip
     fi
  od
  /* Note: this version doesn't terminate all processes - only the leader. We could also send a special "finished" message to each process to tidy up. As it is, we get "invalid endstate" failures if we search for them (but the computed leader ID is correct). */
}
