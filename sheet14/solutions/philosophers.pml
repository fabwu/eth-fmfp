/* This Promela model of the dining philosophers can deadlock.
 * 
 * Assuming that you use xSpin 5.2.5 (with Spin 6.2.1), you can
 * witness a deadlock by "Run.."  -> "Set Verification Parameters.."
 * and checking "Safety (state)" -> "Invalid Endstates".
 * If you then "Run" spin, it should report an "invalid end state".
 * "Run Guided Simulation.." until it stops and you should see
 * that all philosophers are stuck waiting for a fork to become
 * available.
 */

#define N 5

bit fork[N];

init {
  int i = 0;
  do
  :: i < N -> atomic { 
                printf ("Philosopher %d takes a seat,\n", i);
                run philosopher(i); 
                i = i + 1
              }
  :: i == N -> break
  od
}


#define leftFork(p) p % N
#define rightFork(p) (p + 1) % N


inline pickUpLeft(p) {
  atomic {
    fork[leftFork(p)] == 0;
    fork[leftFork(p)] = 1;
    printf("Philosopher %d picks up the left fork (Fork %d)\n", 
           p, leftFork(p))
  }
}

inline pickUpRight(p) {
  atomic {
    fork[rightFork(p)] == 0;
    fork[rightFork(p)] = 1;
    printf("Philosopher %d picks up the right fork (Fork %d).\n", 
           p, rightFork(p))
  }
}

inline putDownLeft(p) {
  atomic {
    fork[leftFork(p)] = 0;
    printf("Philosopher %d puts down the left fork (Fork %d).\n", 
           p, leftFork(p))
  }
}

inline putDownRight(p) {
  atomic {
    fork[rightFork(p)] = 0;
    printf("Philosopher %d puts down the right fork (Fork %d).\n", 
           p, rightFork(p))
  }
}

inline think(p) {
  printf("Philosopher %d is thinking.\n", p)
}
	
inline eat(p) {
  printf("Philosopher %d is eating.\n", p)
}

proctype philosopher(int p) {
  do
  :: think(p) /* philosopher decides to think */
  :: /* philosopher decides to eat */
     if  /* choose nondeterministically the order to pick up the forks */
     :: pickUpLeft(p); pickUpRight(p)
     :: pickUpRight(p); pickUpLeft(p)
     fi;

     eat(p);  /* eventually eat some spaghetti from the platter */

     if /* choose nondeterministically the order to put down the forks */
     :: putDownLeft(p); putDownRight(p)
     :: putDownRight(p); putDownLeft(p)
     fi
  od
}
