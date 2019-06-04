/* Doens't work but I couldn't figure out why... */

#define N 5 /* number of processes in the ring */ 
#define L 1 /* length of a channel */

chan c[N] = [L] of { byte };

proctype pnode(chan _in, out; byte id) {   
    byte m;
    out ! id;

    do
    :: 
        _in ? m;
        if
        :: m == id -> printf("%d is the leader\n", m);
        :: m > id -> out ! m
        :: m < id -> skip
        fi
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
}