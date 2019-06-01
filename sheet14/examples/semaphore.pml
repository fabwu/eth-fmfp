init {
  run semaphore('A');
  run semaphore('B');
}

bit locked;

proctype semaphore(byte c) {
  /* lock */
   atomic { /* try with and without the atomic block (running many times from the command-line) */
   locked == 0; 
   locked = 1;
   }

  printf("%c\n", c);
  printf("%c\n", c);
  
  /* unlock */
  locked = 0;
}
