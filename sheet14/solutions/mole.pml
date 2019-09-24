bool holes[5]=false;
bool caught=false;

/*Model a move of the mole*/
inline moleMoves() {
	if
	:: holes[0] -> holes[0]=false; holes[1]=true; /*the mole can move only to right*/
	:: holes[4] -> holes[4]=false; holes[3]=true; /*the mole can move only to left*/
	:: holes[1] -> holes[1]=false;
		if
		:: holes[0]=true;
		:: holes[2]=true;
		fi
	:: holes[2] -> holes[2]=false;
		if
		:: holes[1]=true;
		:: holes[3]=true;
		fi
	:: holes[3] -> holes[3]=false;
		if
		:: holes[2]=true;
		:: holes[4]=true;
		fi
	fi
}

/*Check if the mole is in one given hole*/
inline checkHole(i) {
  if 
  :: !caught -> printf ("Checking hole:%d, ",i);
                printf ("Holes: %d %d %d %d %d", holes[0], holes[1], holes[2], holes[3], holes[4]); 
	           if :: holes[i] -> printf ("Caught! "); caught = true; :: else -> skip; fi;
  :: else -> skip;
  fi
}

init {
	/*Initial random state*/
	if
	:: holes[0]=true;
	:: holes[1]=true;
	:: holes[2]=true;
	:: holes[3]=true;
	:: holes[4]=true;
	fi;
	
	/*Strategy*/
	checkHole(1); moleMoves();
	checkHole(2); moleMoves();
	checkHole(3); moleMoves();
	checkHole(1); moleMoves();
	checkHole(2); moleMoves();
	checkHole(3); moleMoves();
	
	/*Final assertion*/
	assert(caught)
}