module ConcatMap where

concatMap' f = foldr aux e
    where
    aux x y = (f x) ++ y 
    e = []


myFoldl f v l = undefined