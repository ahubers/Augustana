{--# LANGUAGE NoImplicitPrelude #--}
module WhyFPMatters where

--------------------------------------------------------------------------------
-- imports 

import Prelude hiding 
  (sum, foldr, concat, length, map, repeat, sqrt, filter, any, all, const, succ, reverse)

intToFloat :: Int -> Float 
intToFloat = fromIntegral

--------------------------------------------------------------------------------
-- =============================================================================
-- Map and reduce, But not map-reduce!
-- Alex Hubers
-- =============================================================================
{-  
  # INTRODUCTION 

  (If this information is not announced before my presentation:)
   Hello, my name is Alex Hubers. I am finishing up my doctorate at the University
   of Iowa where I do research in functional programming, programming language theory,
   and type theory.

   # Motivation

   As an undergraduate, I majored in both Computer Science and Mathematics.
   I distinctly remember at that time pondering about how to make programming
   more like mathematics. For example:
     - Set-theoretic *functions* are a cornerstone of mathematics. 
     - Programming languages have these things called  functions / routines / methods.
   I was always curious if there was a way to view programs as mathematical functions.
   I'd like to open with a question:
   **For the audience, what are some differences between the two?**
   (WRITE ANSWERS ON BOARD)
   Expected answers:
     - programming functions have *side effects*, e.g.:
       - can manipulate program state, mutate variables
       - exceptions
       - randomness
       - can print / read inputs and outputs
   This sort of question lead me to my research in programming language theory and,
   in particular, to **pure** functional programming. Here:
    - "functional programming" means functions are first-class entities, 
       i.e., can be inputs/output from other functions, and 
    - **pure** means "like a mathematical function" or, 
       specifically, that functions have no side-effects.

   One pure functional programming language is Haskell, 
   which will be the language we use today.

   So far we've talked about what pure FP *doesn't* have. 
   Today I would like to explain the great things it *does* have.

   ON BOARD:
   ## Learning Objectives
   - Learn the basics of a different programming paradigm 
     (pure functional programming)
   - Learn some syntax, programming idioms, and semantics of a 
     pure functional language (Haskell)
   - Learn how to compose small, simple programs modularly into larger, 
     more elaborate programs
   - Learn to reason about programs equationally

   ## Thesis
   My thesis is that pure functional programs enables a style of highly reusable,
   clean, and easy-to-reason-about modularity. This modularity permits higher
   productivity, meaning:
     - small modules can be coded quickly and easily
     - General purpose-modules can be reused, leading to faster development 
       of subsequent programs
     - Modules can be tested independently, reducing time spent debugging

-}
--------------------------------------------------------------------------------
-- # Writing Haskell functions
-- 
-- Haskell functions are written by *case analysis*. This is sort of like a "switch"
-- statement, if you're familiar. Let's start by writing the fibonacci sequence.
-- #############################################################################
-- QUESTION: CAN ANYONE REMIND ME HOW TO COMPUTE THE n'TH FIBONACCI NUMBER?

fib :: Int -> Int 
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)
-- #############################################################################

-- The definition of `fib` is written exactly as we might write it 
-- mathematically:
-- WRITE ON BOARD:
--  fib(n) = { 
--     0                        if n = 0 
--     1                        if n = 1
--     fib(n - 1) + fib(n - 2)  otherwise
--  }

-- Here are some fibonacci numbers.
-- ############################################################################# 
-- NOTE that FUNCTION APPLICATION IS WRITTEN WITH SPACES, so we write
--   fib n
-- instead of fib(n).
-- #############################################################################

fib5 :: Int
fib5 = fib 5

-- >>> fib5 
-- 8

fib6 :: Int
fib6 = fib 6  

--- >>> fib6
-- 13

-- The type of fib is annotated with the syntax 
--   fib :: Int -> Int 
-- We can also ask Haskell to tell us the type of fib like so:
-- >>> :t fib 
-- fib :: Int -> Int
--         ^       ^
--         input  output

-- #############################################################################
-- QUESTION: WE'VE BEEN TOLD THAT THE TYPE OF fib IS Int -> Int
-- (READ "int TO int"). WHAT DO WE THINK THIS MEANS?
--  
-- 
-- You might be more familiar with syntax like this:
--
--   function fib(Int n) : Int {
--    ... 
--   }
--
-- But we use arrows to denote inputs and outputs in Haskell.
--------------------------------------------------------------------------------
-- **The next Haskell feature we will use is Haskell's list type, 
-- which are similar to python lists**

-- Lists can be specified similarly to how is done in Python. 
-- There are smarter ways of writing this but we'll keep things simple for now. 
fibs :: [Int]
fibs = [fib 0, fib 1, fib 2, fib 3, fib 4, fib 5, fib 6, fib 7, fib 8, fib 9]

-- >>> fibs
-- [1,1,2,3,5,8,13,21,34,55]


--------------------------------------------------------------------------------
-- **I now want to talk about functions of multiple arguments in Haskell.
-- One such function is `take`:**

-- We can use the function "take" to take the first 5 elements from fibs.
firstFiveFibs :: [Int]
firstFiveFibs = take 5 fibs
--               ^   ^       ^
--               |   |       |
--        function   arg     arg

-- >>> firstFiveFibs
-- [1,1,2,3,5]

-- Let's look at the type of `take`.
-- >>> :t take 
-- take :: Int -> [a] -> [a]

-- The `take` function illustrates two crucial components of programming in Haskell:
--  **partial application** and **polymorphism**. 
--------------------------------------------------------------------------------
-- **Let's first talk about partial application.**

-- #############################################################################
-- ASK AUDIENCE: WHAT ARE THE INPUTS AND WHAT ARE THE OUTPUTS TO THIS FUNCTION?
-- take :: Int -> [a] -> [a]
--          ^      ^      ^ 
--        input  input  output 
-- You might be more familiar with syntax like this:
--
--   function take(Int x , List<a> xs) : List<a> {
--    ... 
--   }
-- 
-- In Haskell, additional arguments to a function are listed to the
-- left of arrows. 
-- #############################################################################
--
-- take :: Int -> [a] -> [a]
--         ^       ^
--         input  input
-- 
-- In general, a function that takes a tuple of inputs is equivalent
-- to a function that takes one input and returns a function expecting another
-- input. For example, the two functions below are equivalent:
-- 
-- the "curried" form 
cnst :: Int -> Int -> Int
cnst x y = x
-- The "uncurried" form
cnst' :: (Int , Int) -> Int
cnst' (x , y) = x 

-- The crucial difference between these two definitions 
-- is that the first function, cnst, can be "partially" applied:
g :: Int -> Int
g = cnst 1

-- Partial application is *VERY* important to understand.
-- Another example: as (+) :: Int -> Int -> Int, we have:
succ :: Int -> Int 
succ = (+) 1

-- COMPREHENSION CHECK: What does the following list evaluate to?
t0 :: [Int]
t0 = [g 1337, succ (g 0) ]
-- >>> t0
-- [1,2]

-- #############################################################################
-- **I next want to talk about polymorphism in Haskell.** 
-- ASK AUDIENCE: CAN SOMEONE EXPLAIN TO ME WHAT POLYMORPHISM IS IN A LANGUAGE
-- LIKE JAVA? GIVE AN EXAMPLE OF A POLYMORPHIC CLASS.
-- #############################################################################
--
-- Returning to our examples:
-- The function `take` is **polymorphic.**
-- That means this function works over lists containing *any type*!
-- We specify polymorphism in type signatures using *type variables*,
-- which are analogous to Java's "generics".
-- 
-- take :: Int -> [a] -> [a]
--                 ^      ^ 
--                 type variables

-- As `take` is polymorphic, we can use it on lists containing anything!
-- For example, Strings in Haskell are just lists of `Char`acters. 
e0 :: String
e0 = take 5 "Hello World"
-- >>> e0
-- "Hello"

e1 :: [Bool] 
e1 = take 3 [True , False, True , False ]
-- >>> e1 
-- [True,False,True]

e2 :: [[Int]]
e2 = take 2 [[1] , [2] , [1, 2, 3]]
-- >>> e2 
-- [[1],[2]]

--------------------------------------------------------------------------------
-- **List syntax**
-- 
-- We can think of a list as having two cases. Either:
-- - The list is empty: [], or
-- - The list has a head and tail (x : xs)
--                                 ^    ^
--                              head    tail

-- The syntax ":" is an infix operator called "cons" that
-- appends an element to a list:
-- >>> :t (:)
-- (:) :: a -> [a] -> [a]

-- Example lists:
--  - The empty list: [] , 
--  - A singleton list: 1 : [] ,  
--  - A list with three elements: 1 : 2 : 3 : [] 
-- Note that [1, 2, 3] is just syntactic sugar for 1 : 2 : 3 : [].
-- I can prove this to you!
sameLists :: Bool 
sameLists = [1, 2, 3] == 1 : 2 : 3 : []
-- >>> sameLists
-- True

-- Likewise, any infix operator can be written in prefix form 
-- by surrounding the operator with parentheses:
sameLists' :: Bool 
sameLists' = 1 : 2 : 3 : [] == (:) 1 ((:) 2 ((:) 3 []))

-- >>> sameLists'
-- True

--------------------------------------------------------------------------------
-- **Now let's talk about writing our own functions over lists**.

-- In Haskell, it suffices to provide the behavior of `sum` on just the
-- cases where the list is empty [], or the list is cons'd (x : xs).
-- For example, we can sum a list of integers.
sum :: [Int] -> Int 
sum []       = 0 
sum (x : xs) = x + sum xs 

-- Examples:
-- >>> sum [1, 2, 3]
-- 6
-- >>> sum firstTenFibs
-- 231

-- Another example: checking if any boolean in a list is true:
checkTrue :: [Bool] -> Bool 
checkTrue []       = False
checkTrue (x : xs) = x || checkTrue xs 

-- >>> checkTrue [True , False]
-- True

-- #############################################################################
-- QUESTION: What's the pattern in `sum` and `checkTrue`? How might we abstract
-- this behavior?
-- 
-- The functions above replace each (:) with a binary operator (·) and each
-- [] with a default value e: 
--   x1 : x2 : ... : xn : [] 
-- and turn them into
--   x1 · x2 · ... · xn · e

-- #############################################################################

--------------------------------------------------------------------------------
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
-- Note that we define `fold` by case analysis on `xs`.
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

-- Now we may write sum as a fold:
sum' :: [Int] -> Int 
sum' xs = fold (+) 0 xs

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

-- We can use fold to test whether any list of booleans is true:
anyTrue :: [Bool] -> Bool
anyTrue bs = fold (||) False bs

-- >>> anyTrue [True, False, False]
-- True

-- Or if all the booleans in a list are true:
allTrue :: [Bool] -> Bool 
allTrue bs = fold (&&) True bs

-- >>> allTrue [True , False]
-- False

-- Another useful fold is to get the length of a list.
-- Note that it's polymorphic as we don't actually interact at all
-- with the contents of the list.
length :: [a] -> Int 
length xs = fold incr 0 xs 
  where 
    incr :: a -> Int -> Int
    incr a b = b + 1
   

-- #############################################################################
-- QUESTION: WHAT DOES THIS FUNCTION DO?
-- Hint: employ equational reasoning!
-- And recall that 
-- (:) :: a -> [a] -> [a]
h :: [a] -> [a]
h xs = fold (:) [] xs

-- (If audience needs more help:)
--   h [1, 2, 3]
-- = fold (:) [] (1 : 2 : 3 : [])
-- = (:) 1 (fold (:) [] (2 : 3 : []))
-- ... 
-- = (:) 1 ((:) 2 ((:) 3 []))
--   {switch to infix}
-- = 1 : 2 : 3 : [] 
-- 
-- Thus:
-- >>> h [1, 2, 3]
-- [1,2,3]

-- `h` seems fairly useless (it's just the identity function) but we can
-- use its idea to build other list primitives, for example: 
-- `snoc` is the opposite of cons: it adds an element to the tail of the list.
snoc :: a -> [a] -> [a]
snoc a xs = fold (:) [a] xs

-- >>> snoc 4 [1, 2, 3]
-- [1,2,3,4]

-- #############################################################################
-- A similar idea to snoc: concatenation of lists.
-- Given lists xs = [x1 , x2, ... , xn] and ys = [y1, y2, ... , ym], 
-- the concatenation of xs to ys is the list 
--   [x1 , ... , xn , y1, ... , ym]
-- EXERCISE: HOW CAN WE DEFINE CONCAT AS A FOLD?
concat :: [a] -> [a] -> [a]
concat xs ys = fold (:) ys xs -- undefined

-- NOTE: concat IN HASKELL CAN BE WRITTEN IN INFIX NOTATION USING ++:
-- >>> [1, 2, 3] ++ [4, 5, 6]
-- [1,2,3,4,5,6]

-- EXERCISE: HOW CAN WE REVERSE A LIST?
reverse :: [a] -> [a]
reverse xs = fold snoc [] xs

-- >>> reverse [1, 2, 3, 4]
-- [4,3,2,1]

--------------------------------------------------------------------------------
-- *I next want us to graduate to what's called "point-free" notation.* 
-- That is, let's stop thinking about what functions do to lists and think 
-- more about what functions do to functions.

-- function composition is defined directly as:
compose :: (b -> c) -> (a -> b) -> (a -> c)
compose f g a = f (g a) 

-- Equivalently, we can use the period notation `.` as an
-- infix composition operator. This style of notation
-- is called "point-free" because we have omitted the "point" `a`.
compose' :: (b -> c) -> (a -> b) -> (a -> c)
compose' f g = f . g

-- #############################################################################

-- Function composition allows us to conconct more intricate folds by 
-- composing smaller functions into bigger ones. For example,
-- We can filter elements out of a list that don't match some predicate f. 
-- (I am also going to switch to point-free notation.)
filter :: (a -> Bool) -> [a] -> [a]
filter f = fold (concat . filt) []
  where 
    filt x = if f x then [x] else []

isEven :: Int -> Bool
isEven n = n `mod` 2 == 0
-- >>> filter isEven [1..10]
-- [2,4,6,8,10]

-- #############################################################################
-- QUESTION: 
--   - (1) WHAT IS THE TYPE OF THIS FUNCTION? 
--   - (2) WHAT DOES THIS FUNCTION DO?
-- N.b. (> 0) is a partial application of (>), so 
-- (> 0) is a function that is true if its input is > 0 and false otherwise.
w = (> 0) . length . filter isEven 


-- During a fold, we can also effectively manipulate the elements of a list,
-- leaving the structure otherwise in place. 
doubleall :: [Int] -> [Int]
doubleall = fold ((:) . (* 2)) []
--- >>> doubleall [2, 4, 6]
-- [4,8,12]

-- Another pattern arises! 
invert :: [Bool] -> [Bool]
invert = fold ((:) . not) []

-- >>> invert [False , True]
-- [True,False]

--------------------------------------------------------------------------------
-- Mapping

-- We can generalize by replacing `double` with an arbitrary function
-- `f : a -> b`. Then `map` is a function that applies `f` to each 
-- element of `xs :: [a]` to return a list of type `[b]`.
map' :: (a -> b) -> [a] -> [b]
map' f = fold ((:) . f) []

-- `map` is more traditionally defined directly:
map :: (a -> b) -> [a] -> [b]
map f [] = [] 
map f (x : xs) = f x : map f xs

-- #############################################################################
-- EXERCISE: WHAT DOES map f [x1 , x2 , ... , xn] COMPUTE TO?
--           USE EQUATIONAL REASONING!
-- ANSWER:
-- We have
--   map f (x1 : x2 : ... : xn : [])
-- = f x1 : (map f (x2 : ... : xn : []))
-- = f x1 : f x2 : ... : f xn : (map f [])
-- = f x1 : f x2 : ... : f xn : [] 
-- = [f x1 , f x2 , ... , f xn]
-- #############################################################################

-- Mapping is sort of like a for loop. Here I turn every number
-- in a list into a string using `show`:
--   show :: Int -> String
-- >>> map show [1, 2, 3]
-- ["1","2","3"]

-- We can do quite a lot combining map and fold. `all` takes a predicate 
-- `f` and returns true if every element of xs satisfies f. 
all :: (a -> Bool) -> [a] -> Bool
all f = allTrue . map f

-- Example:
-- >>> all (> 0) [1..10]
-- True

any :: (a -> Bool) -> [a] -> Bool
any f = anyTrue . map f

-- >>> any isEven [1..10]
-- True

-- #############################################################################
-- For another example, note that we can view a matrix as a list of lists. 
matrix :: [[Int]]
matrix = [
    [1 , 0 , 0],
    [0 , 1 , 0],
    [0 , 0 , 1]]

-- The `sumMatrix` function sums all the elements in the matrix.
-- EXERCISE: HOW CAN WE USE `sum` AND `map` TO ADD ALL THE ELEMENTS
-- OF A MATRIX?
-- Hint:
-- >>> map sum matrix
-- [1,1,1]

sumMatrix :: [[Int]] -> Int 
sumMatrix = sum . map sum -- undefined

-- >>> sumMatrix matrix
-- 3
-- #############################################################################
--
-- Here is a really succinct and clever way of defining the powerset of a list.
-- (Ask the class what the powerset is...)
powerset :: [a] -> [[a]]
powerset []       = [[]]
powerset (x : xs) = map (x :) (powerset xs) ++ powerset xs

-- >>> powerset [1, 2, 3]
-- [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]]

--------------------------------------------------------------------------------
-- A cool feature of Haskell: "Lazy" functional programming

-- Our last topic is *laziness*. Laziness means "expressions are not evaluated
-- until we poke them." For example, I can *define* infinite lists:
-- QUESTION: WHAT LIST DOES THIS COMPUTE?
-- [ ? , ? , ? , ... ]
infty :: [Int]
infty = 0 : map succ infty

-- Let's quick employ some equational reasoning:
--   infty 
-- = 0 : map succ infty 
-- = 0 : map succ (1 : map succ infty)
-- = 0 : succ 0 : map succ (map succ infty)
-- = 0 : 1 : map succ (map succ infty)
-- = 0 : 1 : map (succ .succ) infty 
-- = 0 : 1 : map (succ . succ) (0 : map succ infty)
-- = 0 : 1 : (succ . succ) 0 : map (succ . succ . succ) infty 
-- = 0 : 1 : 2 : ... 

-- Why can I define this list without my program looping forever? Because I haven't
-- actually "inspected" or "used" this list at all, yet. For example, evaluating
-- the following will loop forever:
-- >>> infty

-- *but* I can take a finite amount of elements from it:
-- >>> take 10 infty
-- [0,1,2,3,4,5,6,7,8,9]

-- We are free to perform operations over infinite lists
allEvens :: [Int]
allEvens = map (*2) infty

-- >>> take 10 allEvens 
-- [0,2,4,6,8,10,12,14,16,18]

allOdds :: [Int]
allOdds = map (+ 1) allEvens

-- >>> take 10 allOdds
-- [1,3,5,7,9,11,13,15,17,19]

-- #############################################################################
-- We can define a function to compute a list of repeated applications: 
--    [a , f a , f (f a) , f (f (f a)) , ... ]
-- CHALLENGE: ANYONE WANT TO TAKE A SHOT AT BUILDING THIS LIST?
-- Hint: Abstract `0` and succ in this definition. 
--   infty :: [Int]
--   infty = 0 : map succ infty

repeat :: (a -> a) -> a -> [a]
repeat f a = a : map f (repeat f a) 
-- #############################################################################

--------------------------------------------------------------------------------
-- Why have laziness? Certain "infinite programs" can have useful 
-- *finite observations*!
--
-- ## Newton-Raphson algorithm 
-- SAY: The Newton-Raphson algorithm computes the square root of a number `n` by starting
-- from an initial approximation a0 and computing better and better approximations
-- using the following recurrence relation:
-- WRITE ON BOARD:
--   aᵢ₊₁ = (aᵢ + n/aᵢ)/2
-- (Explaining recurrence relation): A recurrence relation specifies a sequence
-- of numbers recursively. For example,
--   fib₀ = 1 
--   fib₁ = 1 
--   fibᵢ = fibᵢ₋₁ + fibᵢ₋₂
-- For the Newton-Raphson algorithm:
--   a₀ = a₀ 
--   a₁ = (a₀ + n/a₀) / 2
--   a₂ = (a₁ + n/a₁) / 2 
--   ...
-- 
-- The algorithm works because, if the approximation converges to some limit, 
-- that is if lim_{i → ∞} aᵢ = a, then
--    a = (a + n/a)/2
-- => 2a = a + n/a
-- => a = n/a
-- => a*a = n
-- => a = sqrt(n)

-- We can model one step of this sequence using the `next` function:
next :: Float -> Float -> Float
next n a = (a + n / a) / 2

-- We wish to repeat this computation, yielding a sequence as follows:
-- [ a0 , next n a0 , next n (next n a0) , next n (next n (next n a0)) , ...]

-- #############################################################################

-- Now we can compute the first 10 approximations of the square root of 2 
-- using an initial approximation of 1. 

sqrt2 :: [Float]
sqrt2 = repeat (next 2.0) 1.0
-- DISSECTING THIS DEFINITION USING EQUATIONAL REASONING:
-- - (next 2.0) :: Float -> Float 
--   next 2.0 a = (a + 2.0 / a) / 2.0
--   Hence (next 2) is a function that computes the approximation aᵢ₊₁ given input aᵢ.
-- -   repeat (next 2.0) 1.0  
--   = [1.0] ++ [next 2.0 1.0 , next 2.0 (next 2.0 1.0) , ... ]
--   = [1.0 , (1.0 + 2.0 / 1.0) / 2.0 , next 2.0 (next 2.0 1.0) , ...]
--   = [1.0 , 1.5 , next 2.0 1.5 , ... ]
-- >>> take 10 sqrt2
-- [1.0,1.5,1.4166667,1.4142157,1.4142135,1.4142135,1.4142135,1.4142135,1.4142135,1.4142135]
-- 
-- #############################################################################
-- QUESTION 1: WHAT SEEMS TO BE HAPPENING TO THE ENTRIES IN THIS LIST?
-- QUESTION 2: WHEN SHOULD WE STOP COMPUTING THE SEQUENCE AND TAKE A VALUE AND SAY 
-- "GOOD ENOUGH"?
-- ANSWER: When computing a converging term, standard practice is to compute approximations
-- until some accuracy is reached. We model this accuracy by an epsilon in difference
-- between successive numbers. For example, we might compute approximations until
-- two successive numbers are only 0.001 apart.
-- #############################################################################

-- The `within` function will iterate over a list and terminate once
-- two successive values are "close enough" according to some epsilon.
within :: Float -> [Float] -> Float 
within eps (x : y : xs) = if abs (y - x) < eps then y else within eps (y : xs)

-- Finally, we can reach a diverging approximation to the Newton-Raphson algorithm
-- by gluing the pieces together:
-- #############################################################################
-- QUESTION: HOW DO WE GLUE THESE PIECES TOGETHER?
sqrt :: Float -> Float -> Float -> Float
sqrt a0 eps n = within eps (repeat (next n) a0) -- undefined 
-- Arguments:
--  - a0 is the initial approximation
--  - eps is the difference in successive numbers at which we will return a number
--  - n is the number for which we are computing the square root
-- HINT:
--   USE `within` on a generalization of `sqrt2` ABOVE.
-- #############################################################################

-- We compute the sqrt of 2 given an initial approximation of 1 and an epsilon of 0.01
-- >>> sqrt 1 0.01 2
-- 1.4142157

--------------------------------------------------------------------------------
-- We can use the `within` function to compute any converging series.
-- What about the ratio of two successive fibonacci numbers?

-- First, as we will be dividing successive fibonacci numbers, we need to 
-- work with `Float`s (not `Int`s). We write fib' to return Floats. 
fib' :: Int -> Float
fib' = intToFloat . fib 
-- >>> take 10 (map fib' infty)
-- [1.0,2.0,3.0,5.0,8.0,13.0,21.0,34.0,55.0,89.0]

-- We are going to introduce & use Haskell's built-in notation 
-- for infinite lists & list comprehensions:
ratios :: [Float]
ratios =  [ fib' n / fib' (n - 1) | n <- [1..]]

-- >>> take 10 ratios
-- [1.0,2.0,1.5,1.6666666,1.6,1.625,1.6153846,1.6190476,1.617647,1.6181818]

-- And we can compute this term to arbitrary precision as so:
ratio :: Float -> Float
ratio eps = within eps ratios

-- >>> ratio 0.001
-- 1.6181818

-- >>> ratio 0.00000001
-- 1.618034

-- Does anyone know what this ratio is?

--------------------------------------------------------------------------------
-- Summary
--
-- Functional programming permits a wide degree of *modularity*. Through the use of generic
-- combinators, we can express a multitude of programs. I have only sampled an *extremely tiny* portion
-- of what Haskell and functional programming can offer. If this stuff interests you, I
-- recommend the following resources:
--   - Learn You a Haskell For Great Good: A Beginner's Guide, Miran Lipovaca. 
--     https://learnyouahaskell.github.io/ 
--   - Algorithm Design with Haskell. Richard Bird and Jeremy Gibbons. 
--   - (Advanced) Programming Language Foundations in Haskell. Philip Wadler, Wen Kokke, Jeremy G. Siek.
--     https://plfa.github.io/ 
--
-- I am happy to take questions now!
