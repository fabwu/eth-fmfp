module Coins where

coins = [5,10,20,50,100,200,500]

cntChange :: Int -> Int
cntChange a = aux a coins
    where
        aux a' coins'
            | a' == 0 = 1
            | a' < 0 = 0
            | a' > 0 && null coins' = 0
            | otherwise = (aux a' (tail coins')) + (aux (a'-(head coins')) coins')
