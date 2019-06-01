int x;

init {
  x = 0;
  run EvenRun();
  run EvenRun();

  /* wait for processes to terminate */
  _nr_pr == 1;

  printf("x: %d\n", x);
  assert x % 2 == 0;
}

proctype EvenRun() {
  int y;
  y = x;
  y = y + 1;
  x = y;
  y = x;
  y = y + 1;
  x = y;
  printf("addTwo terminates\n");
}
