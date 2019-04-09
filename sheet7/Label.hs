module Label where

import Control.Monad.State.Lazy

data Tree a = Leaf | Node a (Tree a) (Tree a)  deriving (Show, Eq)

-- labelInOrder :: Tree a -> Tree Int
-- labelInOrder = fst . aux 0 
--   where 
--     aux :: Int -> Tree a -> (Tree Int, Int)
--     aux state Leaf = (Leaf, state)
--     aux state (Node x l r) = 
--       let (l', state')   = aux state l
--           state''        = state' + 1
--           x'             = state''
--           (r', state''') = aux state'' r
--       in (Node x' l' r', state''')
      

labelInOrder :: Tree a -> Tree Int
labelInOrder t = fst $ runState (renameTree t) 0

renameTree :: Tree a -> State Int (Tree Int)
renameTree Leaf = return Leaf
renameTree (Node x l r) = do
  l' <- renameTree l
  x' <- increment
  r' <- renameTree r
  return (Node x' l' r')
  
increment :: State Int Int
increment = do
  counter <- get
  let x' = counter + 1
  put x'
  return x'
  