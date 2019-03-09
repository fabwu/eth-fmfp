module Palindromes where

palindromes :: [String] -> [String]
palindromes xs = [ v ++ w | 
                            v <- xs, 
                            w <- xs, 
                            v ++ w == reverse (v ++ w)
                    ]
    