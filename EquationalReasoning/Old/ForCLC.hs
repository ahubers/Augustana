{--# LANGUAGE NoImplicitPrelude #--}
module WhyFPMatters where

--------------------------------------------------------------------------------
-- imports 

import Prelude hiding 
  (sum, concat, length, map, repeat, sqrt, filter, any, all, const, succ, reverse)

--------------------------------------------------------------------------------
-- =============================================================================
-- Introduction to higher-order functional reasoning
-- Talk for Augustana College, Weds Feb 25, 2026
-- Alex Hubers
-- =============================================================================

{-

  # This Talk

  First, what is "pure functional programming":
  - "functional programming", I mean that functions are first-class entities,
     that is, can be inputs/outputs to other functions
  - "Pure" I mean "like a mathematical function", or, "has no side-effects":
     Side effects:
     - Mutable state
     - Exceptions
     - Randomness
     - Reading input/ output from the world

    ## Thesis
    - Pure FP enables a style of highly reusuable, clean, and easy-to-reason about modularity.

    ## Learning Objectives
    - Learn the basics of a different programming paradigm (pure FP) in a pure functional
      language (Haskell)
    - Learn how to read and write higher-order programs
    - Learn how to compose  small, simple programs into larger, elaborate programs
    - to learn how to reason equationally about programs

GENERAL FEEDBACK:
-- - See if I can make parts of this more slidey
     - Typing English is eating up time unnecessarily
   - Bring back question about math function vs. comp sci functions?
   - Clean up learning objectives verbiage
   - Remove thesis in favor of just learning objectives
   - Can I go without type signatures entirely?
-}

--------------------------------------------------------------------------------
--
-- In Haskell, we write functions by case analysis:
length [] = 0
length (x : xs) = 1 + length xs


{-
def length(xs):
   match xs:
      case []:
         return 0
      case [x , *xs]:
         return 1 + length(xs)
-}

-- FEEDBACK: POINT OUT USE OF EVALUATION HERE?
-- 
-- >>> length [1, 2, 3]
-- 3

-- length([1, 2, 3])

--------------------------------------------------------------------------------
-- FEEDBACK:
--   - distinction between compile time & runtime type checking not important.
--   
-- >>> :t +d length 
-- length :: [a] -> Integer

--------------------------------------------------------------------------------
-- Polymorphism!
-- FEEDBACK: Don't mention polymorphism, just ask about Java generics.

-- >>> length [1, 2, 3]
-- 3

-- >>> length ["a" , "b"]
-- 2

-- >>> length [length , length , length]
-- 3

--------------------------------------------------------------------------------
-- Partial application
-- FEEDBACK: THIS section does not pay off.
-- 

const :: a -> b -> a
const x y = x

const' :: (a , b) -> a
const' (x , y) = x

{-
function (x : a, y : b) : a {
  return x;
}
-}

-- crucial difference:
g :: b -> Int
g = const 1

{-
  Let y :: b be arbitrary. Then:
    g y
  = const 1 y
  = 1 
-}


t0 :: Int
t0 = g "foobar"

-- >>> t0
-- 1



add :: Int -> Int -> Int
add x y = x + y

successor :: Int -> Int
successor = add 1

-- >>> successor 3
-- 4


--------------------------------------------------------------------------------
--

sum :: [Int] -> Int
sum []       = 0
sum (x : xs) = x + sum xs
{-
Again, here's how you would write this function in Python:

def sum(xs):
   match xs:
      case []:
         return 0
      case [x , *xs]:
         return x + sum(xs)

FEEDBACK:
-- USE COMPREHENSION OR FOR LOOP AS EXAMPLE AND DEMONSTRATE
   HOW THAT DOESN'T LEAD TO PLEASANT EQUATIONAL REASONING.
-- ASK students what it does and then why do they know that
-- 
-}

checkTrue :: [Bool] -> Bool
checkTrue []       = False
checkTrue (x : xs) = x || checkTrue xs

{-

FEEDBACK: Put this in comments around `sum` def'n.

sum [] = 0
         ^
sum (x : xs) = x + sum xs
                 ^ 
-}

-- FEEDBACK: Lead up to `fold` by generalized sum one piece of
-- at a time.
-- FEEDBACK: Just start writing fold w/o type signature.

-- fold :: (a -> b -> b) -> b -> [a] -> b
fold f e []       = e
fold f e (x : xs) = f x (fold f e xs)

{-
The arguments to fold!
-- f :: (a -> b -> b) combines the elements of the list
-- e :: b is a "default" case
-- xs :: [a] is the list we're folding over

Let's compute `fold add 0 [1, 2, 3] where
add x y = x + y

  fold add 0 [1, 2, 3]
= fold add 0 (1 : 2 : 3 : [])
= add 1 (fold add 0 (2 : 3 : []))
= add 1 (add 2 (fold add 0 (3 : [])))
= add 1 (add 2 (add 3 0))
= 1 + 2 + 3 + 0

More generally:
  fold f x (x1 : x2 : ... : xn : [])
= f x1 (f x2 (... (f xn x)))
-}

--------------------------------------------------------------------------------
--

sum' :: [Int] -> Int
sum' xs = fold add 0 xs

-- >>> sum' [1, 2, 3]
-- 6

-- ?
mult x y = x * y

prod :: [Int] -> Int
prod xs = fold mult 1 xs

-- >>> prod [1, 2, 3]
-- 6

anyTrue :: [Bool] -> Bool
anyTrue xs = fold (||) False xs

-- >>> anyTrue [False]
-- False


cons :: a -> [a] -> [a]
cons x xs = x : xs

h :: [a] -> [a]
h xs = fold cons [] xs

{-

  h [1, 2, 3]
= fold cons [] (1 : 2 : 3 : [])
= cons 1 (fond cons [] (2 : 3 : []))
= ...
= cons 1 (cons 2 (cons 3 []))
= [1, 2, 3]

-}

-- when I write fold f e xs
-- what is e?
snoc :: a -> [a] -> [a]
snoc a xs = fold cons [a] xs

-- >>> snoc 3 [1, 2]
-- [1,2,3]

-- concat [x1, ... , xn] [y1 , ... yn]
-- =  [x1 , ... , xn , y1 , ... , yn]
-- FEEDBACK: Switch this with reverse.
-- concat :: [a] -> [a] -> [a]
-- concat xs ys = fold cons ys xs

reverse :: [a] -> [a]
reverse xs = fold snoc [] xs
