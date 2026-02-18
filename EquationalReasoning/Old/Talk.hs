module FP where
import Prelude hiding 
  (sum, concat, length, map, repeat, sqrt, filter, any, all, const, succ, reverse, unlines)

{-
- Talk for Augustana College, Weds Feb 25, 2026
- Alex Hubers, University of Iowa

# This talk

## what separates a mathematical function from a programming language function?
- Consistency of inputs / outputs 
  - Every input uniquely determines an output, and
  - every function *must* return an output
- PL functions have "side effects":
  - There's mutable state
  - Exceptions can be thrown
  - Read input / output

Two distinguishing features of Haskell functions:
1. Functions have no side-effects (purity)
2. Functions can be inputs/outputs of other functions (higher-order)

## learning objectives
From this talk, you will learn how to:
- Write higher-order programs in Haskell
- Reason equationally about programs 

I'm typing in the comments of a Haskell file! here's some code:
-} 

x = 1 + 1 
s = "hello" ++ " " ++ "world"

-- I can evaluate code in comments, like this:
-- >>> x 
-- 2

-- >>> s 
-- "hello world"

--------------------------------------------------------------------------------
-- First: why is purity desirable?

--------------------------------------------------------------------------------
-- 

sum []       = 0 
--             ^                
sum (x : xs) = x + sum xs
--               ^ 

-- 1. What does this function do?
--    Same thing. It sums a list. 

-- Note! In Haskell, write function application delimited with spaces,
-- so we write:
-- >>> sum [1, 2, 3]
-- 6
-- not sum([1, 2, 3]). (no parentheses necessary.)
-- Also! 
--   [1, 2, 3]
-- is syntactic sugar for:
--   1 : 2 : 3 : [] 
-- 
-- >>> 1 : [] 

-- 2. How do I know it accomplishes this? 
--    I can show you! 
-- 3. Can I prove it sums a list?
--    Yes. 

-- Pf. 
-- Let xs = x1 : x2 : ... : xn : [] be an arbitrary list.
-- sum []       = 0                                 (0)
-- sum (x : xs) = x + sum xs                        (1)

{- 
  sum xs
= sum (x1 : (x2 : ... : xn : []))
  {apply equation (1)}
= x1 + (sum (x2 : ... : xn : []))
  {}
= x1 + x2 + (sum (... : xn : []))
= x1 + x2 + ... + xn + sum [] 
= x1 + x2 + ... + xn + 0 
= x1 + x2 + ... + xn
-}

--------------------------------------------------------------------------------
-- Let's write some programs similar to `sum`. 


prod []       = 1
prod (x : xs) = x * prod xs

-- >>> prod [1, 2, 3] 
-- 0

-- How aout a function that checks if any boolean in a list of booleans is true?
-- want anyTrue [True , True]
--      = True || True = True 
--      anyTrue [False , False]
--      = False || False = False 
anyTrue []       = True     
anyTrue (x : xs) = x || anyTrue xs  

--   anyTrue [x1 , x2 , ... , xn ]
-- = x1 || x2 || ... || xn || True 

--------------------------------------------------------------------------------
-- Generalizing `sum`, `prod`, `anyTrue`

fold f e []       = e
fold f e (x : xs) = f x (fold f e xs)

-- What does fold do?
-- Specification:
--   fold f e (x1 : x2 : ... : xn : [])
-- = f x1 (f x2 (... (f xn e)))
-- (This is just prefix-notation for)
-- x1 + x2 + ... + xn + 0 
-- but we replaced (+) with f and 0 with e. 








