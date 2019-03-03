module OneTimePad where

otp :: [Bool] -> [Bool] -> [Bool]
otp key msg = map aux (zip key msg)
-- otp key msg = zipWith aux' key msg
    where
        aux :: (Bool, Bool) -> Bool
        aux (False, False) = False
        aux (True, False) = True
        aux (False, True) = True
        aux (True, True) = False

        aux' :: Bool -> Bool -> Bool
        aux' False False = False
        aux' True False = True
        aux' False True = True
        aux' True True = False
    