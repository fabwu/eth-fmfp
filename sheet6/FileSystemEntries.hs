module FileSystemEntries where

data FSEntry = Folder String [FSEntry] | File String String

-- (a)

fFSE :: (String -> [a] -> a) -> (String -> String -> a) -> FSEntry -> a
fFSE fFolder fFile = go
  where
    go (File x y) = fFile x y
    go (Folder x xs) = fFolder x $ map go xs

-- (b)

number :: FSEntry -> Int
number = fFSE (\_ y -> 1 + (foldr1 (+) y)) (const $ const 1)

count :: Char -> FSEntry -> Int
count needle = fFSE (\_ xs -> foldr1 (+) xs) (\_ txt -> length $ filter (== needle) txt)

-- (c)

paths :: FSEntry -> [String]
paths = fFSE fFolder fFile
  where
    fFolder :: String -> [[String]] -> [String]
    fFolder x = concatMap (map (\z -> x ++ "/" ++ z))
    fFile :: String -> String -> [String]
    fFile x _ = [x]