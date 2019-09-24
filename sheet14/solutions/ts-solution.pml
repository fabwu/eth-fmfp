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

// NOTE: you need to uncomment only one of these at a time (Spin will only check a single ltl block, at least in some versions - you should get a console warning about this if you try to include more than one).

// ltl { <> [] (r==true) };
// ltl { [] <> (r==true) };
// ltl { [](p==true) };
// ltl { (p==true) W [](q==true || r==true) };
// ltl { (<>[](p==true)) -> (<>[](r==true)) };
