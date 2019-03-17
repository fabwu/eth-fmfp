module Redefine where

{-
    In this exercise you are required to adapt the following function implementations of
    f, g and h such that foldl, foldr, zip, zipWith, filter, curry, uncurry, etc. will
    be used. That means, your task is to modify the lines 10-11, 15-19 and 23-28.
-}

f :: [[a]] -> [a]
f = foldr (\x y -> reverse x ++ y)  []

f' :: [[a]] -> [a]
f' [] = []
f' (x:xs) = reverse x ++ f' xs

g :: Eq a => [a] -> [a] -> [a]
g = ((map fst . filter (uncurry (==))) .) . zip

g' :: Eq a => [a] -> [a] -> [a]
g' [] _ = []
g' _ [] = []
g' (x:xs) (y:ys)
        | x == y = x : g' xs ys
        | otherwise = g' xs ys

h :: [Int] -> Int
h = foldr (\_ y -> y + 1) 0 . filter even

h' :: [Int] -> Int
h' = aux 0
    where
        aux z [] = z
        aux z (x:xs)
            | even x = aux (1 + z) xs
            | otherwise = aux z xs

iszero :: Int -> Bool
iszero x = x == 0