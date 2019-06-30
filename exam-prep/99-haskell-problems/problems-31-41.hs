-- https://wiki.haskell.org/99_questions/31_to_41

-- problem 31
-- slow and naive implementation
isPrime :: Int -> Bool
isPrime x = isPrime' x (x-1)
    where
        isPrime' :: Int -> Int -> Bool
        isPrime' x 1 = True
        isPrime' x y = (x `mod` y) /= 0 && isPrime' x (y-1)

-- problem 32
myGCD :: Int -> Int -> Int
myGCD x 0 = x
myGCD x y = myGCD y (x `mod` y)

-- problem 33
coprime :: Int -> Int -> Bool
coprime x y = myGCD x y == 1

-- problem 34
totient :: Int -> Int
totient 1 = 1
totient x = length (filter (coprime x) [1..(x-1)])

totient' :: Int -> Int
totient' n = length [x | x <- [1..(n-1)], coprime x n]

-- problem 35
primeFactors :: Int -> [Int]
primeFactors 1 = []
primeFactors x = aux x [y | y <- [2..x], isPrime y]
        where
            aux 1 primes = []
            aux x primes 
                | x `mod` p == 0 = [p] ++ (aux (x `div` p) primes)
                | otherwise = aux x (tail primes)
                where p = head primes
                
-- problem 36
prime_factors_mult :: Int -> [(Int, Int)]
prime_factors_mult 1 = []
prime_factors_mult x = 
                let primes = primeFactors x in
                aux (tail primes) (head primes, 1) 
            where
                aux :: [Int] -> (Int, Int) -> [(Int,Int)]
                aux [] p = [p]
                aux (y:ys) (a,b)
                    | y == a = aux ys (a,b+1)
                    | otherwise = [(a,b)] ++ aux ys (y,1)

-- problem 37
totientonsteroids :: Int -> Int
totientonsteroids x = foldr (\(p,m) y -> y * (p-1) * p ^ (m-1)) 1 (prime_factors_mult x)

-- problem 38

-- ?

-- problem 39
primesR :: Int -> Int -> [Int]
primesR a b = [x | x <- [a..b], isPrime x]

-- problem 40
goldbach :: Int -> (Int, Int)
goldbach x = head [(a,b) | a <- primesR 2 x, b <- primesR 2 x, a+b==x]

-- problem 41
goldbachList :: Int -> Int -> [(Int,Int)]
goldbachList a b = [goldbach x | x <- [a..b], even x]

goldbachList' :: Int -> Int -> Int -> [(Int,Int)]
goldbachList' a b l = filter (\(a,b) -> a > l && b > l) $ goldbachList a b