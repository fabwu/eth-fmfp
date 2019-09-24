bool enter[2];  /* enter[i] iff process i would like to enter the critical section */
bit turn;       /* Who may enter the critical section next? */
byte mutex;     /* Number of processes in the critical section */

#define N 5

byte critical = 2;         /* Who is in? "2" signals "nobody" */
byte fair[2]; /* This simulates fairness: after N steps a process blocks necessarily */

proctype process(bit i) {
  do
  :: fair[i]>0 ->
     enter[i] = true; /* Signal interest in entering the critical section ... */
     turn = 1 - i;    /*  ... but let the other one go first */

     enter[1 - i] == false || turn == i; /* Wait until I may enter the critical section */

     mutex++;  /* Enter critical section ... */
	 critical = i;
	 
     fair[1-i] = N;
	 fair[i] = fair[i]-1;
	 
	 mutex--;  /* ... and leave it again */
	 critical = 2;

     enter[i] = false; /* Oh well, the critical section was actually quite boring */
  od
}

proctype supervisor() {
  assert(mutex != 2);
}

init {
  atomic {
    fair[0] = N;
	fair[1] = N;
    run supervisor();
    run process(0);
    run process(1);
  }
}

ltl{ [] <> (critical==0) };