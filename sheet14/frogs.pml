byte stones[7]; // 0 empty 1 male 2 female

proctype frog(byte pos, byte male) {
    stones[pos] = 1;

    do
    :: pos > 0 && pos < 6 && stones[pos - 1] = 0 -> atomic {
        stones[pos] = 0;
        if
        :: male -> pos = pos - 1; stones[pos] = 1;
        :: else -> pos = pos + 1; stones[pos] = 2;
        fi;
    }
    :: pos > 1 && pos < 5 && [pos - 2] = 0 -> atomic {
        stone[pos] = 0;
        if
        :: male -> pos = pos - 2; stones[pos] = 1
        :: else -> pos = pos + 2; stones[pos] = 2
        fi
    }
    :: else -> skip
    od;
};

init {
    frog(0,false);frog(1,false);frog(2,false);
    frog(4,true);frog(5,true);frog(6,true);
}