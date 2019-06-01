/* Try setting these values to 2,2 and then increasing */
#define N 5
#define C 5

bit Account_locks[N];

inline lock(n) {
  printf("Process %d attempts to lock account %d\n", _pid, n);
  atomic {
    Account_locks[n] == 0;
    Account_locks[n] = 1;
    printf("Process %d locked account %d\n", _pid, n);
  }
}

inline choose(a, l, u) {
  a = l;
  do
  :: (a < u) -> a++
  :: break
  od
}

inline chooseAccounts(f, t) {
  do
  :: (f != t) -> break 
  :: (f == t) -> choose(f, 0, N-1); choose(t, 0, N-1)
  od
}

inline chooseAccounts2(f, t) {
  choose(f, 0, N-2);
  choose(t, f+1, N-1);
}

active [C] proctype transfer() {
  byte from, to;

  /* choose accounts non-deterministically */
  chooseAccounts2(from, to);

  /* acquire locks */
  lock(from);
  lock(to);

  /* actual transfer omitted */

  /* release locks */
  Account_locks[from] = 0;
  printf("Process %d released account %d\n", _pid, from);
  Account_locks[to] = 0;
  printf("Process %d released account %d\n", _pid, to);
}
