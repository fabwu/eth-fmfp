data Unit = U
data Boolean = F | T
data IList = INil | ICons Int IList
data Tree a = Leaf | Node a (Tree a) (Tree a)

fold :: b -> Unit -> b
fold e u = e

fold' :: b -> b -> Boolean -> b
fold' t f b = go b
    where
        go T = t
        go F = f

fold'' :: b -> (Int -> b -> b) -> IList -> b
fold'' e f l = go l
    where
        go INil = e
        go (ICons i x) = f i (go x)

fold''' :: b -> (a -> b -> b -> b) -> Tree a -> b
fold''' e f = go
        where
            go Leaf = e
            go (Node v l r) = f v (go l) (go r)

data Prop a = PVar a | Not (Prop a) |
              And (Prop a) (Prop a) |
              Or (Prop a) (Prop a)

foldProp :: (a -> b) -> (b -> b) -> (b -> b -> b) -> (b -> b -> b) -> Prop a -> b
foldProp vf nf af of' = go
            where
                go (PVar x) = vf x
                go (Not x) = nf (go x)
                go (And l r) = af (go l) (go r)
                go (Or l r) = of' (go l) (go r)

eval :: Prop a -> Boolean
eval = foldProp id 
                