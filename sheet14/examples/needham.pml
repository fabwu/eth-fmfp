
mtype = { msg1, msg2, msg3, 
          keyA, keyB, keyI,
          agentA, agentB, agentI, 
          nonceA, nonceB, nonceI };

typedef Crypt { mtype key, content1, content2 };

chan network = [0] of { mtype, /* msg# */
                        mtype, /* receiver */
                        Crypt };

inline build(m, k, c1, c2) {
  m.key = k;
  m.content1 = c1;
  m.content2 = c2
}

mtype partnerA;
mtype partnerB;
bit statusA; /* 1 = success */
bit statusB; /* 1 = success */


/*------------------------------------------------------------------*
 * ALICE
 *------------------------------------------------------------------*/

active proctype Alice() {
  mtype pkey;      /* the partner's public key           */
  mtype pnonce;    /* nonce that we receive from partner */
  Crypt message;   /* our message to the partner         */
  Crypt data;      /* received message                   */

  if /* choose a partner for this run */
  :: partnerA = agentB; pkey = keyB;
  :: partnerA = agentI; pkey = keyI;
  fi;

  /* Prepare and send first message */  
  build(message, pkey, agentA, nonceA);
  network ! msg1, partnerA, message;

  /* Wait for answer (using pattern matching) */
  network ? (msg2, agentA, data);

  /* Proceed only if the key field of the data matches keyA and the
     received nonce is the one that we have sent earlier */
  (data.key == keyA) && (data.content1 == nonceA);

  /* Obtain partner's nonce */
  pnonce = data.content2;

  /* Prepare and send the last message */  
  build(message, pkey, pnonce, 0);
  network ! msg3, partnerA, message;

  statusA = 1; /* Success */
}


/*------------------------------------------------------------------*
 * BOB
 *------------------------------------------------------------------*/

active proctype Bob() {
  mtype pkey;      /* the other agent's public key                 */
  mtype pnonce;    /* nonce that we receive from the other agent   */
  Crypt message;   /* our encrypted message to the other party     */
  Crypt data;      /* received encrypted message                   */

  /* Wait for a message addressed to us*/
  network ? (msg1, agentB, data);

  /* Block if we cannot decrypt this message */
  data.key == keyB;

  partnerB = data.content1;
  pnonce = data.content2;

  if /* choose key for our partner */
  :: partnerB == agentA; pkey = keyA;
  :: partnerB == agentI; pkey = keyI;
  fi;

  build(message, pkey, pnonce, nonceB)
  network ! msg2, partnerB, message;

  network ? (msg3, agentB, data);

  /* Block if we cannot decrypt this message or if contains the wrong nonce */
  data.key == keyB && data.content1 == nonceB;

  statusB = 1; /* Success */
}


/*------------------------------------------------------------------*
 * INTRUDER
 *------------------------------------------------------------------*/

bool knows_nonceA, knows_nonceB;

inline copy(from, to) {
  to.key = from.key;
  to.content1 = from.content1;
  to.content2 = from.content2
}


active proctype Intruder() {
  mtype tag, recpt;
  Crypt data, intercepted;

  do
  :: network ? (tag, _, data) ->
     if /* perhaps store the message */
     :: copy(data, intercepted);
     :: skip;
     fi;
     if /* record newly learnt nonces */
     :: (data.key == keyI) ->
        knows_nonceA = knows_nonceA || 
                       (data.content1 == nonceA) || 
                       (data.content2 == nonceA);
        knows_nonceB = knows_nonceB || 
                       (data.content1 == nonceB) || 
                       (data.content2 == nonceB);
     :: else -> skip;
     fi;
  :: /* Replay or send a message */
     if /* choose message type */
     :: tag = msg1;
     :: tag = msg2;
     :: tag = msg3;
     fi;
     if /* choose recipient */
     :: recpt = agentA;
     :: recpt = agentB;
     fi;
     if /* replay intercepted message or assemble it */
     :: copy(intercepted, data);
     :: if
        :: data.key = keyA;
        :: data.key = keyB;
        fi;
        if
        ::                 data.content1 = agentA;
        ::                 data.content1 = agentB;
        ::                 data.content1 = agentI;
        :: knows_nonceA -> data.content1 = nonceA;
        :: knows_nonceB -> data.content1 = nonceB;
        ::                 data.content1 = nonceI;
        fi;
        if
        :: knows_nonceA -> data.content2 = nonceA;
        :: knows_nonceB -> data.content2 = nonceB;
        ::                 data.content2 = nonceI;
        fi;
     fi;

     network ! tag, recpt, data;
/* We used this assert statement in class as an indirect way to partially check the desired LTL properties (see below) */
/*assert !(statusA==1 && statusB==1 && knows_nonceA && knows_nonceB);*/
  od
}

/* shorthand macros - it's a good idea to include parentheses around the entire formula defined, to avoid precedence issues */
#define atoB (partnerA==agentB)
#define btoA (partnerB==agentA)

/* This one verifies (if Alice and Bob talk only to each other, all ends well): */
/*ltl { ([](statusA==1 && statusB==1 -> atoB == btoA)) &&
    ([](statusA ==1 && atoB -> knows_nonceA == 0)) &&
    ([](statusB==1 && btoA -> knows_nonceB == 0))}*/

/* This one doesn't verify (if Alice and Bob end *any* run of the protocol, all is well...?): */
/* IMPORTANT: more than one ltl {...} block is not supported; subsequent ones will be IGNORED, so comment-out the above one */
ltl { ([](statusA==1 && statusB==1 -> atoB == btoA)) &&
    ([](statusA ==1 -> knows_nonceA == 0)) &&
    ([](statusB==1 -> knows_nonceB == 0))}
