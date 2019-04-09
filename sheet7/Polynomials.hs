module Polynomials where

type Poly a = [(Integer, [a])]

data SymbExpr a
  = Var a
  | Lit Integer 
  | Add (SymbExpr a) (SymbExpr a)
  | Mul (SymbExpr a) (SymbExpr a)
  deriving Show

-- (a)

evalPoly :: (a -> Integer) -> Poly a -> Integer
evalPoly f = foldr (\(c,vs) -> (+) $ c * (product . map f) vs) 0

-- (b)

foldSymbExpr :: (a -> b) -> (Integer -> b) -> (b -> b -> b) -> (b -> b -> b) -> SymbExpr a -> b
foldSymbExpr fVar fLit fAdd fMul = go
  where
    go (Var x) = fVar x
    go (Lit x) = fLit x
    go (Add x y) = fAdd (go x) (go y)
    go (Mul x y) = fMul (go x) (go y)

-- (c)

-- ?

-- (d)

toPoly :: SymbExpr a -> Poly a
toPoly = foldSymbExpr fVar fLit fAdd fMul
  where
    fVar x = [(1, [x])]
    fLit x = [(x,[])]
    fAdd = foldr (:)
    fMul l r = [(li*ri, lv ++ rv) | (li, lv) <- l, (ri, rv) <- r]