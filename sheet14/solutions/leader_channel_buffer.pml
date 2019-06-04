/* It is not possible for one node to receive more than n messages
 * (one per node). We formalise the property of interest as a single
 * assertion, and placed it into a so-called watchdog process.
 * Spin will test all possible interleavings of the pnode processes
 * and the watchdog process. The resulting set of interleavings will
 * contain those where the single assertion is checked after every
 * possible state change involving the channels. Hence, the
 * assertion must always hold, or Spin will complain.
 *
 * The assertion will fail if you reduce the channel capacity, e.g.,
 * set it back to one again, as used in part a) of the assignment.
 *
 * In case of L = 0, we have synchronous message sending, which
 * means that sends are blocking. For the protocol under study,
 * L = 0 leads to a deadlock (we do not detect this explicitly below,
 * but could do so with extra instrumentation and an LTL formula
 * checking that at it is always the case that at least one process
 * has either terminated or will reach the beginning of its loop again.
 */

#define I 3  /* offset for ID assignment */
#define N 5  /* number of processes in the ring */
#define L 6  /* length of a channel */

chan c[N] = [L] of { byte };

init {
  run watchdog();

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
     :: else ->     /* forget about the id I received, is not the leader's id */
          skip
     fi
  od
}

// note like (unlike in leader.pml) we don't get invalid endstate errors for this model - this is just because the "watchdog" is never stuck..
proctype watchdog() {
  do
  :: assert(nfull(c[0]) && nfull(c[1]) && nfull(c[2]) && nfull(c[3]) && nfull(c[4]));
  od
}
