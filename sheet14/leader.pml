/* Doens't work but I couldn't figure out why... */

#define N 5 /* number of processes in the ring */ 
#define L 1 /* length of a channel */

chan c[N] = [L] of { byte };
int leader = -1;

proctype pnode(chan _in, out; byte id) {   
    byte m;
    out ! id;

    do
    :: leader == -1 -> atomic {
        _in ? m;
        if
        :: m == id -> leader = m
        :: m > id -> out ! m
        fi
    }
    :: else -> break
    od
}

init {
    int id = 1;
    do
    :: (id <= N) -> atomic {
        int new_id = id % N;
        printf("Spawn process %d\n", new_id);
        run pnode(c[id - 1], c[new_id], new_id); 
        id++
    }
    :: (id > N) -> break
    od;

    _nr_pr == 1;
    printf("%d is the leader\n", leader);
}