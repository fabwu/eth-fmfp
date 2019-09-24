//     byte x;

// init {

//     x = 2;
    
//     byte state[3];

//     do
//     :: state[0] == 0 -> atomic {x=1;state[0]=1}
//     :: state[1] == 0 -> atomic {x=2;state[1]=1}
//     :: state[2] == 0 && state[1] == 1 -> atomic {x=x+2;state[2]=1}
//     :: else -> skip
//     od
// }

int x;

proctype p1(){
 x=1;
}

proctype p2(){
 x=2; 
 x=x+2;
}

init{
 x=2;
 run p1();
 run p2();
 _nr_pr == 1; //wait until there is only one process left

}

ltl {<>[](x==1 || x==2 || x==4)}