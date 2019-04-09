module Tree where
    
data Tree t = Leaf | Node t (Tree t) (Tree t)

bfs :: Tree t -> [t]
bfs Leaf = []
bfs (Node x l r) = aux [l,r] [x]
  where
    aux :: [Tree t] -> [t] -> [t]
    aux [] a = a
    aux (Leaf:q) a = aux q a
    aux ((Node x l r):q) a = aux (q ++ [l,r]) (a ++ [x])

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f Leaf = Leaf
mapTree f (Node x l r) = Node (f x) (mapTree f l) (mapTree f r)

sortedTree :: Ord t => Tree t -> Bool
sortedTree = isSorted . inorder
    where
        inorder Leaf = []
        inorder (Node x l r) = (inorder l) ++ [x] ++ (inorder r)
        isSorted [] = True
        isSorted [x] = True
        isSorted (x:y:xs) = x < y && isSorted (y:xs)