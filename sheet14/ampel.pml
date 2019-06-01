bit x = 0, y = 0, z = 1;

init {
s1: // yellow state
  atomic {
    y = 1; z = 0;
  }
s2: // red state
  atomic {
    x = 1; y = 0;
  }
s3: // red-yellow state
  y = 1;
s4: // green state
  atomic {
    z = 1; x = 0; y = 0; goto s1;
  }
}

ltl { [] ((x==1) && (y==1) -> X (z==1)) };
