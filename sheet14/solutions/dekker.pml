bool enter[2];  /* enter[i] iff process i would like to enter the critical section */
bit turn;       /* Who may enter the critical section next? */
byte mutex;     /* Number of processes in the critical section */

proctype process(bit i) {
  do
  :: enter[i] = true; /* Signal interest in entering the critical section ... */
     turn = 1 - i;    /*  ... but let the other one go first */

     enter[1 - i] == false || turn == i; /* Wait until I may enter the critical section */

     mutex++;  /* Enter critical section ... */
     mutex--;  /* ... and leave it again */

     enter[i] = false; /* Oh well, the critical section was actually quite boring */
  od
}

proctype supervisor() {
  assert(mutex != 2);
}

init {
  atomic {
    run supervisor();
    run process(0);
    run process(1);
  }
}
