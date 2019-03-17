takeWhile' p [] = []
takeWhile' p (x:xs) 
    | p x       = x:(takeWhile' p xs)
    | otherwise = []

intersperse' s [] = []
intersperse' s [x] = [x]
intersperse' s (x:xs) = (x:s:intersperse' s xs)

toInt base digits = sum $ zipWith aux digits [0..(length digits)-1]
    where
        aux a b = a*(base^b)

maximum' [] = error("empty list")
maximum' (x:xs) = foldr aux x xs 
    where
        aux x y
            | x > y = x
            | otherwise = y


concatMap' f = foldr (\x l -> f x ++ l) []

iter3 f g x y = (x:y:iter3 f g (f x) (g y))

perfect :: Int -> Bool
perfect n = n == sum [x | x <- [1..(n-1)], n `mod` x == 0]

sum' :: [Int] -> Int
sum' = foldr (+) 0

pad2 c [] = []
pad2 c [x] = [x]
pad2 c (x:xs) = x:c:c:pad2 c xs

and' :: [Bool] -> Bool
and' = foldr (&&) True

or' :: [Bool] -> Bool
or' = foldr (||) False

product' :: [Int] -> Int
product' = foldr (*) 0

all' :: (a -> Bool) -> [a] -> Bool
all' p = foldr (\x y -> (p x) && y) True