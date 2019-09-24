split [] b = [b]
split (x:[]) b = [b ++ [x]]
split (' ':' ':' ':xs) b = [b] ++ split xs ""
split (x:xs) b = split xs (b ++ [x])

mult :: Int -> Int -> Int
mult _ 0 = 0
mult x y = x + mult x (y-1)

log2 :: Int -> Int
log2 1 = 0
log2 x = 1 + log2 (x `div` 2) 

isPrime :: Int -> Bool
isPrime x = isPrime' x (x-1)
    where
        isPrime' :: Int -> Int -> Bool
        isPrime' x 1 = True
        isPrime' x y = (x `mod` y) /= 0 && isPrime' x (y-1)

length_foldl :: [t] -> Int
length_foldl xs = foldl (\y _ -> y+1) 0 xs

last' :: [a] -> a
last' = head . reverse

init' :: [a] -> [a]
init' = reverse . tail . reverse

concat' :: [a] -> [a] -> [a]
concat' [] ys = ys
concat' (x:xs) ys = x:concat' xs ys 

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = concat' (reverse' xs) [x]

get :: [a] -> Int -> a
get xs 0 = head xs
get xs n = get (tail xs) (n-1) 

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x:map' f xs

intersperse' :: a -> [a] -> [a]
-- intersperse' sep xs = tail (foldl (\x y -> x ++ sep:[y]) [] xs)
intersperse' _ [x] = [x]
intersperse' sep (x:xs) = x:sep:intersperse' sep xs

take' :: Int -> [a] -> [a]
take' 0 _ = []
take' n (x:xs) = x:take' (n-1) xs

drop' :: Int -> [a] -> [a]
drop' 0 xs = xs
drop' n (x:xs) = drop' (n-1) xs

splitAt' :: Int -> [a] -> ([a], [a])
splitAt' n xs = (take n xs, drop n xs) 

break' :: (a -> Bool) -> ([a] -> ([a],[a]))
break' f xs = (takeWhile (not . f) xs, dropWhile (not . f) xs)

elem' :: Eq a => a -> [a] -> Bool
elem' n [] = False
elem' n (x:xs)
        | n == x = True
        | otherwise = elem' n xs

concat'' :: [[a]] -> [a]
concat'' = foldr (++) []

pascal :: Int -> [Int]
pascal 1 = [1]
pascal 2 = [1,1]
pascal n = [1] ++ aux (pascal (n-1)) ++ [1]
        where
            aux :: [Int] -> [Int]
            aux [] = []
            aux (x:[]) = []
            aux (x:y:xs) = [x+y] ++ aux (y:xs)

pascalSum :: Int -> Int
pascalSum xs = foldl (+) 0 (pascal xs)

prime :: Int -> Bool
prime n = [1,n] == [x | x <- [1..n], n `mod` x == 0]

mapLC :: (a -> b) -> [a] -> [b]
mapLC f xs = [f x | x <- xs]

filterLC :: (a -> Bool) -> [a] -> [a]
filterLC f xs = [x | x <- xs, f x]

and' :: [Bool] -> Bool
and' = foldr (&&) True

or' :: [Bool] -> Bool
or' = foldr (||) False

sum' :: [Int] -> Int
sum' = foldr (+) 0

product' :: [Int] -> Int
product' = foldr (*) 1

all' :: (a -> Bool) -> [a] -> Bool
all' f = foldr (\x y -> f x && y) True

exists' :: (a -> Bool) -> [a] -> Bool
exists' f = foldr (\x y -> f x || y) False

-- scanl' :: (b -> a -> b) -> b -> [a] -> [b]
-- scanl' f e = foldr (\x y -> y ++ [f (last y) x]) [e] 

ps :: [Int] -> [[Int]]
ps [] = [[]]
ps (x:xs) = map (\y -> x:y) (ps xs) ++ (ps xs)

data Json a = Val a | Obj [(String, Json a)]

instance Eq a => Eq (Json a) where 
    (==) (Val x) (Val y) = x == y
    (==) (Obj xs) (Obj ys) = all (flip elem ys) xs && all (flip elem xs) ys
    (==) _ _ = False

values :: Json a -> [(String, a)]
values (Val x) = [("",x)]
values (Obj xs) = concatMap aux xs
    where
        aux :: (String, Json a) -> [(String, a)]
        aux (key, (Val x)) = [(key, x)]
        aux (key, (Obj xs)) = concatMap (\(k2,x) -> aux (key ++ "." ++ k2, x)) xs

address = Obj [
    ("place", Val "London"),
    ("street", Obj [("name", Val "Baker"),
                    ("no", Val "221b")]),
    ("country", Val "UK")]

group :: Eq a => [a] -> [[a]]
group [] = [[]]
group xs = aux (tail xs) [head xs]
        where
            aux :: Eq a => [a] -> [a] -> [[a]]
            aux [] ys = [ys]
            aux (x:xs) ys
                | x == (head ys) = aux xs (ys ++ [x])
                | otherwise = [ys] ++ (aux xs [x])

encode :: Eq a => [a] -> [(a,Int)]
encode xs = map aux (group xs)
            where
                aux :: [a] -> (a, Int)
                aux [] = error "empty encoding"
                aux ys = (head ys, length ys)
decode :: [(a,Int)] -> [a]
decode xs = concatMap aux xs
                where
                    aux :: (a, Int) -> [a]
                    aux (s,n) = foldr (\_ y -> (s:y)) [] [1..n] 

iterate' f x = (x:iterate f (f x))

psum :: [Int] -> [Int]
psum xs = 0:(aux xs 0)
        where
            aux [] _ = []
            aux (x:xs) t = [x+t] ++ (aux xs (x+t))

data F a = AP a | Not (F a) | And (F a) (F a) | E (F a)

instance Show a => Show (F a) where
    show (AP x) = show x
    show (Not x) = "(Not " ++ show x ++ ")"
    show (And x y) = "("++ show x ++ " && " ++ show y ++ ")"
    show (E x) = "(E "++ show x++")"

dvdNxt :: [Int] -> [Int]
dvdNxt [] = []
dvdNxt [x] = [x]
dvdNxt (x:xs)
    | ((head xs) `mod` x) == 0 = x:(dvdNxt xs)
    | otherwise = dvdNxt xs

stableDN :: [Int] -> [Int]
stableDN xs
    | xs == newList = xs
    | otherwise = stableDN newList
    where
        newList = dvdNxt xs

prepend :: String -> [[String]] -> [String]
prepend s xs = [s ++ x | x <- (concat xs)]

data Interval a = V a a

make :: Ord a => a -> a -> Interval a
make l u
        | l <= u = (V l u)
        | otherwise = (V u l)

instance (Show a) => Show (Interval a) where
    show (V l u) = "["++(show l)++","++(show u)++"]"

intersect [] = Nothing
intersect [x] = Just x
intersect ((V l1 u1):(V l2 u2):rest)
    | max l1 l2 <= min u1 u2   = intersect ((V (max l1 l2) (min u1 u2)):rest)
    | otherwise                = Nothing 


data FSEntry = Folder String [FSEntry] | File String String

test = Folder "Home"[Folder "Work"[File "students.txt" "Alice, Bob",File "hint"         "You can use fFSE!"],File "Fun" "FMFP"]

fFSE folderF fileF = go
    where
        go (Folder s xs) = folderF s (map go xs)
        go (File s1 s2) = fileF s1 s2

number = fFSE (\_ xs -> 1 + (sum xs)) (\_ _ -> 1)

count ch = fFSE (\_ xs -> sum xs) (\_ s -> foldr (\x y -> if x == ch then y + 1 else y) 0 s)

paths (File s _) = [s]
paths (Folder s xs) = prepend (s ++ "/") (map paths xs)

data Seq a = Empty | Single a | Concat (Seq a) (Seq a) deriving Show

foldSeq :: b -> (a -> b) -> (b -> b -> b) -> Seq a -> b
foldSeq empty single concat = go
    where 
        go Empty = empty 
        go (Single a) = single a
        go (Concat l r) = concat (go l) (go r)

seq' = Concat (Concat Empty (Single "moo"))(Concat Empty (Concat (Single "foo") (Single "goo"))) 

filterSeq :: (a -> Bool) -> Seq a -> Seq a
filterSeq p seq = foldSeq Empty aux1 aux2 seq
        where
            aux1 x
                | p x = (Single x)
                | otherwise = Empty
            aux2 :: (Seq a) -> (Seq a) -> (Seq a)
            aux2 x y = (Concat x y)

toSeq [] = Empty
toSeq (x:y:[]) = Concat (Single x) (Single y)
toSeq (x:y:xs) = Concat (Single x) (toSeq (y:xs))

goldbach :: Int -> Bool
goldbach x = (0 < length [1 | a <- [2..x], b <- [2..x], a + b == x, isPrime a, isPrime b]) && ((x `mod` 2) == 0)
            where
                isprime x = 2 == length [x' | x' <- [1..x], x `mod` x' == 0]

cartesian [] = []
cartesian [x] = map (:[]) x
cartesian (x:xs) = concatMap (\z -> map (z:) $ cartesian xs) x

diags xs = [l xs 0, r xs (length xs - 1)]
    where
        l [] _ = []
        l (x:xs) n = (x !! n):(l xs (n+1))
        r [] _ = []
        r (x:xs) n = (x !! n):(r xs (n-1))    

transpose []             = []
transpose ([]   : xss)   = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])
        

isMagic [] = False
isMagic (x:xs) = all test' (x:xs) &&
                 all test' (transpose (x:xs)) &&
                 all test' (diags (x:xs))
    where
        test' x' = (sum x) == (sum x')
    
natPairs = [(a,b) | x <- [1..], a <- [1..x], b <- [1..x], (a+b) == x]

rationals = [(x,y) | (x,y) <- natPairs, gcd x y == 1]

data AList a b = AEnd a | ACons a b (AList a b)

ahead (AEnd x) = x
ahead (ACons x _ _) = x

alast (AEnd x) = x
alast (ACons _ _ l) = alast l

aflat f (AEnd x) = f x
aflat f (ACons x y xs) = f x ++ [y] ++ aflat f xs

data BTree key = Leaf [key] | Node (AList (BTree key) key)

btree = Node(ACons (Leaf [1,2,3]) 4(ACons (Leaf [4,6,6]) 6(ACons (Node(ACons (Leaf [6]) 7(ACons (Leaf []) 7(AEnd  (Leaf [7,8]))))) 8(AEnd  (Leaf [9])))))

issorted [] = True
issorted [x] = True
issorted (x:y:xs) = x <= y && issorted (y:xs)

bsorted (Leaf xs) = issorted xs
bsorted (Node keys) = issorted (aflat aux keys)
        where
            aux :: (BTree key) -> [key]
            aux (Leaf xs) = xs
            aux (Node keys) = aflat aux keys

data Tape = Tape [Int] Int [Int] deriving Show

emptyTape = (Tape [0 | x <- [1..]] 0 [0 | x <- [1..]])

updateTape f (Tape l c r) = (Tape l (f c) r)

moveLeft (Tape l c r) = (Tape (init l) (last l) (c:r))
