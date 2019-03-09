pascal :: Integer -> [Integer]
pascal 1 = [1]
pascal n = (1:(aux $ pascal (n - 1))) 
    where
        aux :: [Integer] -> [Integer]
        aux [x] = [1]
        aux (x:y:xs) = (x+y):aux (y:xs)