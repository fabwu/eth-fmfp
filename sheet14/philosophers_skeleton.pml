#define N 5

bit fork[N];
bit hasEaten[N];
int eatCounter;

/* 

Deadlock occurs if the philosphers pick up the forks in a circle. In my case it was:

Philosopher 4 picked up right fork.
Philosopher 0 picked up right fork.
Philosopher 1 picked up right fork.
Philosopher 2 picked up right fork.
Philosopher 3 picked up right fork.

Now philospher 3 wants to pick up the left fork but philosopher 4 already has this fork.

If we increase the number of philosophers a deadlock gets more unlikly as the probablitiy 
for a cycle decreases.

I think the model is not starvation free because in principle it can happen that a philosopher
is never able to pick up both forks.

In order to check if all philosophers have eaten I simply increment a counter and check with the LTL

<>(eatCounter == N)

if the counter reaches N at some point. When I check the model I get a acceptance cycle error.

Unfortunately, I don't have time for task d.

*/

init {
  int i = 0;
  do
  :: i < N -> atomic { 
                printf ("Philosopher %d takes a seat.\n", i);
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
    fork[leftFork(p)] == false;
    fork[leftFork(p)] = true;
    printf("Philosopher %d picked up left fork.\n", p)
  }
}

inline pickUpRight(p) {
  atomic {
    fork[rightFork(p)] == false;
    fork[rightFork(p)] = true;
    printf("Philosopher %d picked up right fork.\n", p)
  }
}

inline putDownLeft(p) {
  fork[leftFork(p)] = false;
  printf("Philosopher %d put down left fork.\n", p)
}

inline putDownRight(p) {
  fork[rightFork(p)] = false;
  printf("Philosopher %d put down right fork.\n", p)
}


inline think(p) {
  printf("Philosopher %d is thinking.\n", p)
}
	
inline eat(p) {
  printf("Philosopher %d is eating.\n", p);
  if
  :: !hasEaten[p] -> atomic {
    hasEaten[p] = true;
    eatCounter++;
  } 
  fi
}

proctype philosopher(int p) {
  do
  :: think(p) /* philosopher decides to think */
  ::  /* philosopher decides to eat */
     /* pick up forks */

     /*
     // Choose non-deterministically          
     bit leftFirst;

     do
     :: leftFirst = true;break
     :: leftFirst = false;break
     od;

     if
     :: leftFirst -> pickUpLeft(p);pickUpRight(p)
     :: !leftFirst -> pickUpRight(p);pickUpLeft(p)
     fi;
     */

     // No deadlock but starvation
     byte leftFork = leftFork(p);
     byte rightFork = rightFork(p);

     if
     :: leftFork < rightFork -> pickUpLeft(p);pickUpRight(p);
     :: else -> pickUpRight(p);pickUpLeft(p);
     fi;

     eat(p);  /* eventually eat some spaghetti from the platter */

     /* put down forks */
     atomic {     
       putDownLeft(p);
       putDownRight(p);
     }
  od
}

ltl { <>(eatCounter == N) };
