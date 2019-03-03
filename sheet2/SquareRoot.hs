module SquareRoot where

-- write your implementation of the square root here

eps = 0.001

improve :: Double -> Double -> Double
improve x y = (y + x / y) / 2.0

goodEnough :: Double -> Double -> Bool
goodEnough y y' = (abs $ (y - y') / y') < eps

root :: Double -> Double
root x = aux x (improve x 1.0) 1.0
    where 
        aux x y y' 
            | goodEnough y y' = y
            | otherwise = aux x (improve x y) y   

main :: IO ()
main = do
    putStrLn "Compute the root of:"
    x' <- getLine
    let x = (read x' :: Double)
    if x > 0 then do
        putStrLn ("Square root: " ++ show (root x))
        main
    else return ()