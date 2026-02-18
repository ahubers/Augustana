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

   I want to introduce you all today to a subject I love: pure functional
   programming. Some of you that have taken CSC 350 (Principles of Programming
   Languages) may be more familiar than others with this topic.  I would argue
   that functional programming idioms are fast becoming common in many
   professions (such as front-end web development) and that learning some basic
   FP will make you a better programmer.

   First, what is pure functional programming (fp for short):
    - "functional programming" means functions are first-class entities, 
       i.e., can be inputs/output from other functions, and 
    - **pure** means "like a mathematical function" or, 
       specifically, that functions have no side-effects.
       That is, a pure function does not:
       - Have mutable variables or state
       - have exceptions
       - have randomness (each function deterministically pairs inputs to outputs)
       - read inputs / print outputs or interact with the outside world
   This description of FP is negative: it states what pure FP *doesn't* have,
   not what it does have. So let us explore today what FP *does* have.

   ## Thesis
   My thesis is that pure functional programs enables a style of highly reusable,
   clean, and easy-to-reason-about modularity. This modularity permits higher
   productivity, meaning:
     - small modules can be coded quickly and easily

     - General purpose-modules can be reused, leading to faster development 
       of subsequent programs
     - Modules can be tested independently, reducing time spent debugging
      
   I could talk for a semester about FP, but our time is limited so
   I must narrow our scope. Today I want to talk about higher-order functions---
   that is, functions that accept functions as inputs and return functions as outputs.
   Specifically, our learning objectives are:

   ## Learning Objectives
   - Learn the basics of a different programming paradigm (pure functional programming)
     in a pure functional language (Haskell)
   - Learn how to read and write higher-order programs
   - Learn how to compose small, simple programs modularly into larger, 
     more elaborate programs
   - Learn to reason about programs equationally

   We will accomplish these learning objectives in one of my favorite languages,
   Haskell.
-}

--------------------------------------------------------------------------------
-- **Let's start by talking about writing functions over lists in Haskell**.

-- In Haskell, we write functions by *case analysis* on the inputs. The following
-- function computes the length of a list.

length [] = 0
length (x : xs) = 1 + length xs

{-
Here's how you would write this function in Python:

def length(xs):
   match xs:
      case []:
         return 0
      case [x , *xs]:
         return 1 + length(xs)

In Haskell we specify each case on its own line and omit a "return" statement
(functions must always return something!).
-}

-- One major syntactic difference between Haskell and many languages is that in
-- Haskell we write function application with spaces. So we write:
-- >>> length [1, 2, 3]
-- 6
-- >>> length [1..10]
-- 55

-- Instead of length([1, 2, 3]) or length([1..10]).

-- #############################################################################
-- **Haskell is a statically-typed language.**
-- QUESTION: CAN SOMEONE REMIND THE CLASS THE DIFFERENCE BETWEEN A STATICALLY-TYPED
-- LANGUAGE AND A DYNAMICALLY-TYPED LANGUAGE?
-- #############################################################################

-- Each function in Haskell has a *type*. Amazingly, Haskell has *decidable* type inference,
-- meaning it can compute a type for every program we write. We can even ask Haskell
-- to tell us the type of `length`.

-- #############################################################################
-- QUESTION: BUT BEFORE WE DO, WHAT DO WE EXPECT THIS TYPE TO BE? WHAT TYPE INFORMATION SHOULD BE CONVEYED?
-- >>> :t length
--  
-- You might be more familiar with syntax like this:
--
--   function length(List<a> xs) : Int {
--    ... 
--   }
-- But in Haskell we use arrows to describe function types.
-- #############################################################################

-- #############################################################################
-- **I next want to talk about polymorphism in Haskell.** 
-- ASK AUDIENCE: CAN SOMEONE EXPLAIN TO ME WHAT POLYMORPHISM IS IN A LANGUAGE
-- LIKE JAVA? GIVE AN EXAMPLE OF A POLYMORPHIC CLASS.
--
-- Expected: Polymorphism means:
-- - Classes are parameterized by a generic type
-- - functions work over many different types
-- #############################################################################
-- The type of length tells us that length is *polymorphic*, meaning
-- it will work over lists containing *any* type.
--
-- For example:
-- >>> length [1, 2, 3]
-- 3

-- >>> length ["a", "b"]
-- 2

-- We can even take the length of a list containing functions
-- >>> length [length , length , length , length ]
-- 4
--------------------------------------------------------------------------------
-- Next let's talk about partial application.

-- The following function has two inputs and one output:
--    input input output
--       V    V    V
const :: a -> b -> a
const x y = x

-- We could have written this function as expecting a tuple of inputs:
const' :: (a , b) -> a
const' (x , y) = x

-- More analogous to your favorite language:
-- function (x : a , y : b) : a {
--   return x;
-- }

-- The crucial difference between these two definitions 
-- is that the first function, const, can be "partially" applied:
g :: b -> Int
g = const 1

{-
Let's think equationally. Let y :: b be an arbitrary input. Then:
    g y 
  = const 1 y  {replace by g = const 1}
  = ?          {replace by const x y = x}
  ...
  = 1
  
so `g` is a function that always returns 1!
-}

-- #############################################################################
-- COMPREHENSION CHECK: WHAT DOES t0 COMPUTE TO?
t0 :: Int
t0 = g "foobar"

-- >>> t0
-- 1

-- #############################################################################

-- Partial application is *VERY* important to understand.
-- Another example: first define `add`
add :: Int -> Int -> Int
add x y = x + y

-- Now partially apply add
successor :: Int -> Int 
successor = add 1

-- #############################################################################
-- COMPREHENSION CHECK: WHAT DOES t1 COMPUTE TO?
t1 :: Int
t1 = successor (g 0)

-- >>> t1
-- 2

-- #############################################################################
-- Because of first-order functions, function types, and polymorphism,
-- Haskell programs can be *highly* generic.
-- I'm going to introduce a pattern and we'll see if we can abstract it.

-- Here's a function to compute the sum of a list.
sum :: [Int] -> Int 
sum []       = 0 
sum (x : xs) = x + sum xs

{-
Again, here's how you would write this function in Python:

def length(xs):
   match xs:
      case []:
         return 0
      case [x , *xs]:
         return x + sum(xs)
-}

-- >>> sum [1, 2, 3]
-- 6
-- >>> sum [1..10]
-- 55

-- Another example: checking if any boolean in a list is true:
checkTrue :: [Bool] -> Bool 
checkTrue []       = False
checkTrue (x : xs) = x || checkTrue xs

-- #############################################################################
-- QUESTION: What's the pattern in `sum` and `checkTrue`? How might we abstract
-- this behavior?
-- #############################################################################
-- 
-- Abstracting folds:
--
--  Note that only two components of `sum` are specific to computing a sum:
-- 
--   sum []       = 0
--                  ^
--   sum (x : xs) = x + sum xs
--                    ^
-- Let's *abstract* this behavior by replacing 0 with a default case and 
-- replacing (+) with an arbitrary function `f`. 
fold :: (a -> b -> b) -> b -> [a] -> b
fold f e [] = e
fold f e (x : xs) = f x (fold f e xs)
-- 
-- Let's look at the arguments:
-- - f :: (a -> b -> b) combines the elements of the list
-- - d :: b is a "default" case
-- - xs :: [a] is the list we're folding over.
-- 

-- #############################################################################
-- EXERCISE ON BOARD:
-- LET'S COMPUTE fold add 0 [1 , 2 , 3], where add x y = x + y
--   - start with:
--       fold add 0 [1 , 2, 3]
--     = fold add 0 (1 : 2 : 3 : [])                 {change list syntax}
--     = add 1 (fold add 0 (2 : 3 : []))             {second equation}
--     = add 1 (add 2 (fold add 0 (3 : [])))         {second equation}
--     = add 1 (add 2 (add 3 (fold add 0 [])))       {second equation}
--     = add 1 (add 2 (add 3 0))                     {first equation}
--     = 1 + (add 2 (add 3 0))                       {definition of add}
--     = 1 + (2 + (3 + 0))                           {definition of add}
-- What we've done just now is called *Equational Reasoning*, which is a 
-- powerful tool permitted in Haskell because functions are *pure*.
-- More generally, we have:
-- 
-- WRITE ON BOARD:
--       fold f x (x1 : x2 : ... : xn : [])
--     = f x1 (f x2 (... (f xn x)))                  {first & second equation}
-- #############################################################################
-- For the remainder of the class I want us to practice write common functions
-- using `fold`.

-- Now we may write sum as a fold:
sum' :: [Int] -> Int 
sum' xs = fold add 0 xs

-- >>> sum' [3,7,10]
-- 20

-- We can do lots of cool things with fold.
-- #############################################################################
-- EXERCISE: HOW WOULD WE WRITE THE PRODUCT OF A LIST USING fold?

prod :: [Int] -> Int 
prod xs = fold (*) 1 xs -- undefined
-- >>> prod [1, 2, 3]
-- 6
-- #############################################################################
-- 
-- EXERCISE: How can we use fold to test whether any list of booleans is true:
anyTrue :: [Bool] -> Bool
anyTrue bs = fold (||) False bs

-- >>> anyTrue [True, False, False]
-- True

-- #############################################################################


-- Or if all the booleans in a list are true:
allTrue :: [Bool] -> Bool 
allTrue bs = fold (&&) True bs

-- >>> allTrue [True , False]
-- False

-- #############################################################################
-- QUESTION: WHAT DOES `h` COMPUTE?
-- Hint: employ equational reasoning!

cons :: a -> [a] -> [a]
cons x xs = x : xs
 
-- >>> cons 1 [2, 3]
-- [1,2,3]


h :: [a] -> [a]
h xs = fold cons [] xs

-- give ~15 seconds, then go through the following exercise:
--   h [1, 2, 3]
-- = fold cons [] (1 : 2 : 3 : [])
-- = cons 1 (fold cons [] (2 : 3 : []))
-- ... 
-- = cons 1 (cons 2 (cons 3 []))
--   {switch to infix}
-- = 1 : 2 : 3 : [] 
-- 
-- Thus:
-- >>> h [1, 2, 3]
-- [1,2,3]

-- `h` seems fairly useless (it's just the identity function) but we can
-- use its idea to build other list primitives, for example: 
-- `snoc` is the opposite of cons: it adds an element to the end of the list.
snoc :: a -> [a] -> [a]
snoc a xs = fold cons [a] xs

-- >>> snoc 4 [1, 2, 3]
-- [1,2,3,4]

-- #############################################################################
-- A similar idea to snoc: concatenation of lists.
-- Given lists xs = [x1 , x2, ... , xn] and ys = [y1, y2, ... , ym], 
-- the concatenation of xs to ys is the list 
--   [x1 , ... , xn , y1, ... , ym]
-- EXERCISE: HOW CAN WE DEFINE CONCAT AS A FOLD?
concat :: [a] -> [a] -> [a]
concat xs ys = fold cons ys xs -- undefined

-- NOTE: concat IN HASKELL CAN BE WRITTEN IN INFIX NOTATION USING ++:
-- >>> [1, 2, 3] ++ [4, 5, 6]
-- [1,2,3,4,5,6]

-- EXERCISE: HOW CAN WE REVERSE A LIST?
reverse :: [a] -> [a]
reverse xs = fold snoc [] xs

-- >>> reverse [1, 2, 3, 4]
-- [4,3,2,1]

filter :: (a -> Bool) -> [a] -> [a]
filter f = fold (concat . filt) []
  where 
    filt x = if f x then [x] else []

isEven :: Int -> Bool
isEven n = n `mod` 2 == 0

-- >>> filter isEven [1..10]
-- [2,4,6,8,1]0

--------------------------------------------------------------------------------
-- CONCLUSION:
