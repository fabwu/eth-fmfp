module Words where

split :: Char -> String -> [String]
split s y = aux y "" []
    where
        aux :: String -> String -> [String] -> [String]
        aux [] a l = reverse (("":l))
        aux (x:xs) a l
            | x == s = aux xs "" (a:l)
            | xs == [] = reverse ((a++[x]):l)
            | otherwise = aux xs (a ++ [x]) l

isASpace :: Char -> Bool
isASpace x = x == ' '

toWords :: String -> [String]
toWords = filter (/= "") . split ' '

countWords :: String -> Int
countWords = length . toWords
