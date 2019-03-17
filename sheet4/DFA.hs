module DFA where

import Prelude hiding (Word)

type State = Int
type Alphabet a = [a]
type DFA a = 
    ( Alphabet a             -- alphabet
    , State                  -- initial state
    , State -> a -> State    -- transition function
    , State -> Bool)         -- test for final state
type Word a = [a]

alphabet :: DFA a -> Alphabet a
alphabet (x, _, _, _) = x

initial :: DFA a -> State
initial (_, x, _, _) = x

transition :: DFA a -> (State -> a -> State)
transition (_, _, x, _) = x

finalState :: DFA a -> State -> Bool
finalState (_, _, _, x) = x

{-
    With accessors we give every entry in the tuple an explicit name so it makes
    the code more readable and better to understand. A nicer way would be to use
    record syntax which generates accessors for a data type.
-}

accepts :: DFA a -> Word a -> Bool
accepts dfa = finalState dfa . foldr (\x y -> (transition dfa) y x) (initial dfa)

lexicon :: Alphabet a -> Int -> [Word a]
lexicon sigma 0 = [[]]
lexicon sigma len = [x:y | x <- sigma, y <- lexicon sigma (len - 1)]

language :: DFA a -> Int -> [Word a]
language dfa = filter (accepts dfa) . lexicon (alphabet dfa)

-- Try to use map, foldl, foldr, filter and/or list comprehensions.