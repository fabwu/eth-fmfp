module Complex where

    -- write your implementation of complex numbers here
    
    re :: (Double, Double) -> Double
    re (x, y) = x
    
    im :: (Double, Double) -> Double
    im (x,y) = y
    
    conj :: (Double, Double) -> (Double, Double)
    conj (x,y) = (x,(-1)*y)
    
    add :: (Double, Double) -> (Double, Double) -> (Double, Double)
    add (x,y) (u,v) = (x+u, y+v)
    
    mult :: (Double, Double) -> (Double, Double) -> (Double, Double)
    mult (x,y) (u,v)= (u*x-v*y,v*x+u+y)
    
    absv :: (Double, Double) ->  Double
    absv (x,y) = sqrt (x^2+y^2)
    
    main :: IO ()
    main = do
        putStrLn "Enter your complex number's real component:"
        x <- getLine
        putStrLn "Enter your complex number's imaginary component:"
        y <- getLine
        putStrLn ("Your complex number's absolute value is: " ++ show (absv (read x :: Double, read y :: Double)))