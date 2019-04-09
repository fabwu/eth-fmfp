module Tasks where

-- (a)

match :: String -> Bool
match = aux [] 
  where
    aux :: [Char] -> String -> Bool
    aux stack [] = length stack == 0
    aux stack ('(':xs) = aux ('(':stack) xs
    aux stack ('{':xs) = aux ('{':stack) xs
    aux [] (')':ys) = False
    aux [] ('}':ys) = False
    aux (x:xs) (')':ys) = if x == '(' then aux xs ys else False
    aux (x:xs) ('}':ys) = if x == '{' then aux xs ys else False
    aux stack (x:xs) = aux stack xs

-- (b)

risers :: Ord a => [a] -> [[a]]
risers [] = []
risers (x:xs) = reverse (aux x xs [] [])
  where
    aux x [] [] result = [[x]] ++ result
    aux x [] acc result =  [(acc ++ [x])] ++ result
    aux x (y:ys) acc result
      | x <= y = aux y ys (acc ++ [x]) result
      | otherwise = aux y ys [] [(acc ++ [x])] ++ result