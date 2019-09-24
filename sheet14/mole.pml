byte hole[5];
byte catched;

inline move() {
    if
    :: hole[0] -> hole[0] = false; hole[1] = true
    :: hole[4] -> hole[4] = false; hole[3] = true
    :: hole[1] -> hole[1] = false;
        if
        :: hole[0] = true
        :: hole[2] = true
        fi
    :: hole[2] -> hole[2] = false;
        if
        :: hole[1] = true
        :: hole[3] = true
        fi
    :: hole[3] -> hole[3] = false;
        if
        :: hole[2] = true
        :: hole[4] = true
        fi
    fi
}

inline check(id) {
    if
    :: !catched -> 
        printf("Checking hole %d \n",id);
        if
        :: hole[id] -> atomic { printf("Catched in hole %d \n", id); catched = true; }
        :: else -> printf("Hole %d is empty \n", id);
        fi
    :: else -> skip
    fi
}

init {
    if
    :: hole[0] = true;
    :: hole[1] = true;
    :: hole[2] = true;
    :: hole[3] = true;
    :: hole[4] = true;
    fi;

    check(1); move();
    check(2); move();
    check(3); move();
    check(1); move();
    check(2); move();
    check(3);

    assert catched == true;
}