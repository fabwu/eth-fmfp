bool p = true, q = false, r = false; //starting at s1

init
{
  if
  :: goto s3;
  :: goto s4;
  fi;

  s2:
    atomic{
      p = false;
      q = false;
      r = true;
    }
    goto s4;

  s3:
    atomic{
      p = false;
      q = true;
      r = true;
    }
    goto s4;

  s4:
    atomic{
      q = true;
      p = false;
      r = false;
    }
    if
    :: goto s2;
    :: goto s3;
    :: goto s5;
    fi;

  s5:
    atomic{
      p = true;
      q = true;
      r = true;
    }
    if
    :: goto s4;
    :: goto s5;
    fi;
}

ltl {(<>[]p) -> (<>[]r)}