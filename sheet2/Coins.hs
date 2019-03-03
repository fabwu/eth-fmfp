module Coins where

-- write your implementation for the coin change here
-- Write a Haskell function cntChange :: Int -> Int that computes the number of ways to change any given amount of money (expressed in Rappen) by using CHF coins.

-- Hint: Think recursively. The number of ways to change amount a
-- using n different kinds of coins is equal to the sum of 
-- - the number of ways to change a using all but the first kind of coin, and
-- - the number of ways to change amount a−d using the n kinds of coins, where d is the denomination (Stückelung) of the first kind of coin.

-- cntChange 5 = 1
-- cntChange 10 = 2 (two 5 Rappen and one 10 Rappen)

cntChange :: Int -> Int
cntChange = undefined