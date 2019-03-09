module OneTimePad where

otp :: [Bool] -> [Bool] -> [Bool]
-- otp key msg = map (/=) (zip key msg)
otp = zipWith (/=)