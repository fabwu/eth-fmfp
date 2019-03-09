module PrimeNumbers where

prime :: Int -> Bool
prime 1 = False
prime n = [x | x <- [1..floor $ sqrt $ fromIntegral n], n `mod` x == 0] == [1]

primes :: Int -> [Int]
primes m = [x | x <- [1..m], prime x]

firstPrimes :: Int -> [Int]
firstPrimes m = take m [x | x <- [1..], prime x]
-- firstPrimes m = aux 0 []
--     where
--         aux :: Int -> [Int] -> [Int]
--         aux x xs
--             | length xs == m = xs
--             | otherwise = aux (x+1) (primes x)