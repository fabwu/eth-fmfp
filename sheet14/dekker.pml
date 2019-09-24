byte mutex = 0;
byte id_in_crit_section = -1;
byte wants_to_enter[2];
byte turn = 0;

inline crit(id) {
    atomic {
        printf("%d enters critical section\n", id);
        mutex++;
        id_in_crit_section = id;
        printf("%d leaves critical section\n", id);
        mutex--;
        id_in_crit_section = -1;
        wants_to_enter[id] = 0;
        turn = other_id;
    }
}

proctype p(byte id) {
    byte other_id = (id + 1) % 2;

    do
    ::
        wants_to_enter[id] = 1;
        if
        :: wants_to_enter[other_id] == 0 -> crit(id);
        :: else ->
            do
            :: turn == id -> crit(id);break;
            :: else -> skip;
            od;
        fi;
    od;
}

proctype supervisor() {
    assert(mutex != 2);
}

init {
    run supervisor();
    run p(0);
    run p(1);
}

ltl {[]<>(id_in_crit_section == 1)}