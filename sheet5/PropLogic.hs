module PropLogic where
import Data.List

-- define the data type Prop a here
-- data Prop a = ...

data Prop a = Var a | Not (Prop a) | And (Prop a) (Prop a) | Or (Prop a) (Prop a)

foldProp fVar fNot fAnd fOr (Var x) = fVar x
foldProp fVar fNot fAnd fOr (Not x) = fNot $ foldProp fVar fNot fAnd fOr x
foldProp fVar fNot fAnd fOr (And x y) = fAnd (foldProp fVar fNot fAnd fOr x) (foldProp fVar fNot fAnd fOr y)
foldProp fVar fNot fAnd fOr (Or x y) = fOr (foldProp fVar fNot fAnd fOr x) (foldProp fVar fNot fAnd fOr y)

evalProp :: (a -> Bool) -> Prop a -> Bool
evalProp v = foldProp v not (&&) (||)

propVars :: Eq a => Prop a -> [a]
propVars = foldProp (:[]) id f f
    where
        f [] u = u
        f (x:xs) u
            | x `elem` u = f xs u
            | otherwise = f xs (x:u)  

satProp :: Eq a => Prop a -> Bool
satProp p = [v | v <- subsequences (propVars p), evalProp (`elem`v) p ] /= []

instance Show a => Show (Prop a) where
    show (Var x) = show x
    show (Not x) = "(Not " ++ show x ++ ")"
    show (And x y) = "(" ++ show x ++ " && " ++ show y ++ ")" 
    show (Or x y) = "(" ++ show x ++ " || " ++ show y ++ ")" 