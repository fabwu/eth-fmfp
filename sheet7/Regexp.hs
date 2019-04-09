module Regexp where 

import Expr

-- (a) define the type Regexp here
-- data Regexp = ...

data Regexp = Lit Char | Seq Regexp Regexp | Or Regexp Regexp | Iter Regexp

-- (b)

atom = lit ||| pregexp

iteration = atom ||| piteration

sequence' = iteration ||| psequence

regexp = sequence' ||| por

lit = do 
         x <- sat (\x -> foldr (\y z -> x /= y && z) True ['+', '(', ')', '|'])
         return (Lit x)

pregexp = do char '('
             x <- regexp
             char ')'
             return x
             
piteration = do x <- atom
                char '+'
                return (Iter x)

psequence = do x <- iteration
               y <- sequence'
               return (Seq x y)
               
por = do l <- sequence'
         char '|'
         r <- regexp
         return (Or l r)

str2regexp :: String -> Regexp
str2regexp = completeParse regexp

-- (c)

regexpParser :: String -> Parser ()
regexpParser = regexParser' . str2regexp

regexParser' :: Regexp -> Parser ()
regexParser' (Lit x) = do char x 
                          return ()
regexParser' (Seq x1 x2) = do regexParser' x1
                              regexParser' x2
regexParser' (Or x1 x2) = do regexParser' x1 ||| regexParser' x2
regexParser' (Iter x1) = do many1 (regexParser' x1)
                            return ()
                              
matches :: String -> String -> Bool
matches input rex = any (== ((), "")) (parse parser input)
  where parser = regexpParser rex