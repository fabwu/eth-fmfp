/* This Promela model of the dining philosophers cannot
 * deadlock.
 *
 * Please see the comment at the beginning of
 * philosophers.pml.
 */

#define N 5

bit fork[N];
bit eats[N];

init {
  int i = 0;
  do
  :: i < N -> atomic { 
                printf ("Philosopher %d takes a seat,\n", i);
                run philosopher(i, i == 0); 
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
  eats[p] = true;
  printf("Philosopher %d is eating.\n", p);
  eats[p] = false
}

proctype philosopher(int p; bool leftFirst) {
  do
  :: think(p) /* philosopher decides to think */
  :: /* philosopher decides to eat */
     if  /* Choose the order in which to pick up the forks according to your policy */
     :: leftFirst -> pickUpLeft(p); pickUpRight(p)
     :: !leftFirst -> pickUpRight(p); pickUpLeft(p)
     fi;

     eat(p);  /* eventually eat some spaghetti from the platter */

     if  /* Choose the order in which to put down the forks according to your policy */
     :: leftFirst ->  putDownLeft(p); putDownRight(p)
     :: !leftFirst -> putDownRight(p); putDownLeft(p)
     fi
  od
}

ltl { [] <> (eats[0]==true) };