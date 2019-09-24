-- https://wiki.haskell.org/99_questions/1_to_10

-- problem 1
myLast :: [a] -> a
myLast [x] = x
myLast (x:xs) = myLast xs

-- problem 2
myButLast :: [a] -> a
myButLast xs = head $ tail $ reverse xs

-- problem 3
elementAt :: Int -> [a] -> a
elementAt i xs = xs !!  (i - 1)

-- problem 4
myLength :: [a] -> Int
myLength = foldr (const(+1)) 0

-- problem 5
myReverse :: [a] -> [a]
myReverse xs = aux xs []
    where
        aux [] acc = acc
        aux (x:xs) acc = aux xs (x:acc)  

-- problem 6
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs = xs == reverse xs

-- problem 7
data NestedList a = Elem a | List [NestedList a]
flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List xs) = concatMap flatten xs

-- problem 8
compress :: Eq a => [a] -> [a]
compress xs = aux xs (head xs)
        where
            aux [] last = [last]
            aux (y:ys) last
                | y == last = aux ys last
                | otherwise = [last] ++ aux ys y