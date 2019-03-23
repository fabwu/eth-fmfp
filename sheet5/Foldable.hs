module Foldable where

data Tree3 a = Node (Tree3 a) (Tree3 a) (Tree3 a) | Leaf a

foldTree3 node leaf = go
    where
    go (Node l m r) = node (go l) (go m) (go r)
    go (Leaf a)     = leaf a

instance Foldable Tree3 where
    foldr f e (Leaf a) = f a e
    foldr f e (Node l m r) = foldr f (foldr f (foldr f e r) m) l