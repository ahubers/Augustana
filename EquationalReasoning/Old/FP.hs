module FP where
import Data.Char (toUpper)
import Prelude hiding 
  (sum, concat, length, map, repeat, sqrt, filter, any, all, const, succ, reverse, unlines)

{-
- Talk for Augustana College, Weds Feb 25, 2026
- Alex Hubers, University of Iowa

# This talk

SAY:
Some ground rules:
1. Please just call me Alex.
2. This talk is meant to feel like a classroom, 
   so ask questions and answer mine.


SAY:
Today I want to share a topic I love: functional programming in Haskell.
To keep things accessible, I’ve restricted our scope to one idea:
**equational reasoning**.


SAY: 
To introduce it, here’s a question that fascinated me as an undergrad:

WRITE: 
## How are mathematical function different from programming language functions?
Possible answers:
- A math function always takes the same input to the same output (deterministic)
  - aka, no randomness / probability
  - Must return an output!
- Other "side effects":
  - Mutable state
  - Exceptions
  - Reading input & writing output

## Functions in Haskell
SAY:
Functions in Haskell behave more like mathematical functions. In particular... 
WRITE: 
Two distinguishing features: functions...
- 1. have no side-effects (purity)
- 2. can be inputs/outputs of other functions (higher-order)

WRITE:
## Learning Objectives
You will learn to:
- Write higher-order programs in Haskell
- Reason equationally about programs
-} 

-- SAY:
-- Before we begin, I should comment that... 
-- WRITE:
-- I'm typing in the comments of a Haskell file! Here's some code:
x = 1 + 1
-- I will be evaluating Haskell code in comments like this:
-- >>> x
-- 2
-- >>> "hello" ++ " " ++ "world"
-- "hello world"

--------------------------------------------------------------------------------
-- SAY:
-- First let's talk about why function purity can be desirable.
-- (open Counter.py)

-- Question: Can I replace inc(10) with 11 everywhere in my code? 
--           No. 
-- SAY:
-- inc relies on hidden mutable state, meaning it is not a mathematical function.

--------------------------------------------------------------------------------
-- SAY: 
-- Functions in Haskell are written equationally, with inputs 
-- on the LHS and outputs on the RHS.

sum []       = 0
sum (x : xs) = x + sum xs

-- SAY:
-- - The first equation states that the sum of an empty list is 0.
-- - The second equation breaks the list into a head `x` and tail `xs`,
--   and adds `x` to the result of recursing on `xs`. 
-- SAY: 
-- A sample input. Note that function application omits parentheses 
-- in Haskell. 
-- >>> sum [1, 2, 3]
-- 6
--   
-- SAY:
-- QUESTION: If I see sum [1, 2, 3], can I replace it with 6?
--           Yes. Always. 
-- The slogan is: 
-- - In Python, calling a function is doing something.
-- - In Haskell, calling a function is replacing something.

{- 

We can also directly compute our programs.  

WRITE: 
Let xs = x1 : x2 : ... : xn : [] be an arbitrary list.
  sum xs
= sum (x1 : x2 : ... : xn : [])
  SAY: The key insight is that we may "rewrite" by 
       the equations of `sum` in this term. 
  QUESTION: Which equation applies here?
= x1 + sum (x2 : ... : xn : [])
  Now we use the same equation on the subterm. 
= x1 + x2 + sum (... : xn : [])   
  And repeat. 
= x1 + x2 + ... + xn + sum []
                       ------ 
  QUESTION: Which equation applies now? 
= x1 + x2 + ... + xn + 0
= x1 + x2 + ... + xn

WRITE:
This is called *equational reasoning*. 

SAY:
Equational reasoning makes program behavior easier to predict, 
analyze, optimize, and verify. We can use equational reasoning to
- prove program correctness 
- derive and implement optimizations

SAY:
I next want to introduce (and then reason about!) higher order functions.
-}

--------------------------------------------------------------------------------
-- Let's write some programs similar to `sum`. 

-- SAY: 
-- We can modify the definition of `sum` to compute the product of a list
-- of numbers. 
prod []       = 1
prod (x : xs) = x * prod xs  

-- >>> prod [4, 5, 6]
-- 120

-- SAY: 
-- Here is a function that checks if any Boolean in a list of Booleans is True
anyTrue (x : xs) = x || anyTrue xs 
anyTrue []       = False           

-- SAY:
-- Notice that the only changes we've made are to
-- the base case (what's returned when the list is empty)
-- and the binary operator. 

-- SAY:
-- Computer scientists trade in abstractions. Because these functions are
-- structurally similar, we can abstract this structure into
-- one generic function, then reimplement each function using the generalization.

--------------------------------------------------------------------------------
-- Generalizing `sum`

-- DO IN REAL TIME: transform sum into fold.
-- 1. First rename `sum` to `fold`
-- 2. replace 0 with variable `e`. (Note that additional function arguments are space delimited on the LHS.)
-- 3. Replace + with variable `f`. (note that `fold` is now higher-order.)
--    
-- sum [] = 0
-- sum (x : xs) = x + sum xs 

fold f e [] =  e  
fold f e (x : xs) = f x (fold f e xs) 

{- 
WRITE: 
In general, we can show through equational reasoning that:
  fold f e (x1 : ... : xn : []) = f x1 (f x2 (... (f xn e)))
-}
--------------------------------------------------------------------------------
-- fold in action! 

add x y = x + y 
mult x y = x * y 

-- SAY:
-- Now we can reimplement sum and prod. 
sum' xs = fold add 0 xs 
prod' xs = fold mult 1 xs

-- >>> sum' [1, 2, 3, 4]
-- 10

-- >>> prod' [1, 2, 3, 4]
-- 24


--------------------------------------------------------------------------------
-- SAY: 
-- Let's write some new examples together.

-- SAY:
-- To make things easier to read, let's define `cons` as a function 
-- that adds an element to the front of a list:
cons x xs = x : xs 

-- >>> cons 0 [1, 2, 3]
-- [0,1,2,3]

-- SAY: 
-- Question: what does the following function do?
-- Hint: employ equational reasoning...
h xs = fold cons [] xs 

{- 
If audience needs help: 

  h [1, 2, 3]
= fold cons [] (1 : 2 : 3 : [])
= cons 1 (fold cons [] (2 : 3 : []))
= cons 1 (cons 2 (fold cons [] (3 : []))
= cons 1 (cons 2 (cons 3 (fold cons [] [])))
= cons 1 (cons 2 (cons 3 []))
= 1 : 2 : 3 : [] 
= [1, 2, 3]

So `h` is the identity function!
-}

-- SAY: 
-- `snoc` is like `cons` but backwards: it adds an element
-- to the "end" of the list. 
-- QUESTION: How can I write `snoc` as a fold?
-- Hint: what is the role of "e" in fold f e xs?
snoc a xs = fold cons [a] xs

-- >>> snoc 4 [1, 2, 3]
-- [1,2,3,4]

-- SAY:
-- Here is a fun one:
-- QUESTION: Can we use `snoc` to write `reverse`? 
reverse xs = fold snoc [] xs

--------------------------------------------------------------------------------
-- Mapping

-- SAY: 
-- We're going to write another higher-order function---map. 
-- To illustrate, the following function doubles its input. 
double n = 2 * n 

-- WRITE:
-- Specification:
--   doubleAll [x1, ... , xn] = [2 * x1 , ... , 2 * xn]
doubleAll []       = [] 
doubleAll (x : xs) = double x : doubleAll xs

-- >>> doubleAll [1, 2, 3]
-- [2,4,6]

-- SAY:
-- We can generalize this procedure to get a function called `map`. 
-- Let's replace `double` with an arbitrary function `f`:
-- IN REAL TIME:
-- 1. change doubleAll to map 
-- 2. add f as input 
-- 3. replace double with f 
-- doubleAll []       = [] 
-- doubleAll (x : xs) = double x : doubleAll xs

map f []       =  [] 
map f (x : xs) = f x : map f xs 

-- >>> map double [1, 2, 3]
-- [2,4,6]

-- WRITE:
-- In general, we can show through equational reasoning that:
--   map f [x1 , x2 , ... , xn] = [f x1 , f x2 , ... , f xn]

-- Some more examples of maps 
-- Convert numbers to strings
-- >>> map show [1, 2, 3]
-- ["1","2","3"]

-- Negate every number 
-- >>> map negate [1, -2, 3]
-- [-1,2,-3]

-- Turn characters to uppercase
-- (Note that a string is a list of characters!)
-- >>> map toUpper "I'm not shouting"
-- "I'M NOT SHOUTING"

--------------------------------------------------------------------------------
-- map and fold showcase!

-- SAY: 
-- I find this definition really cool. I encourage you all to try to write a 
-- powerset function of your own---it's surprisingly tricky. 
-- I hope this conveys that these abstractions can be quite powerful! 
powerset []       = [[]]
powerset (x : xs) = map (cons x) (powerset xs) ++ powerset xs

-- >>> powerset [1, 2, 3]
-- [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]]


--------------------------------------------------------------------------------
-- Conclusion






--------------------------------------------------------------------------------
{- Proving properties with equational reasoning!

SAY: 
At this point in the lecture I would distribute worksheets for students
to work together in pairs or groups on more challenging exercises.

Here's a sample exercise: 


# Functor composition 

An important property of mapping is the "functor composition" law. 
Properties such as these can guide program optimizations. 
Notice in the equations below that one of them is computationally cheaper. 

WRITE: 
Function composition is written (f . g) and defined by
  (f . g) x = f (g x)
(1) Use equational reasoning to show that 
      map (f . g) [x1 , ... , xn] = map f (map g [x1 , ... , xn])
    Hint: you may use the equation
      map h [y1 , ... , yn] = [h y1 , ... , h yn]         (equation 1)
    in your reasoning. 

Answer:
  map (f . g) [x1 , ... , xn]
  {equation 1}
= [ (f . g) x1 , (f . g) x2 , ... , (f . g) xn ]  
  {def'n of (.)}
= [ f (g x1) , ... , f (g xn) ]
  {equation 1}
= map f [g x1 , ... , g xn ]
  {equation 1}
= map f (map g [x1 , ... , xn])
as desired. 

(2) Which equation is computationally cheaper? 
      map (f . g) [x1 , ... , xn]
    or 
      map f (map g [x1 , ... , xn])

Answer: 
  The first one only iterates over the list once, and so 
  is cheaper.

(3) Describe how a compiler might optimize code that includes
    nested map expressions. Argue why your proposed optimization 
    would not interfere with the program's meaning.

Answer: 
  A compiler could rewrite subexpressions of the form map f (map g xs)
  to map (f . g) xs. This would not interfere with the program's meaning 
  because the functions f and g are pure and hence referentially transparent.

# Fold fusion

(1) Let xs be an arbitrary list. Prove that 
      h (fold f e xs) = fold g (h e) xs 
    provided that, for all x and y, we have
      h (f x y) = g x (h y).

(2) Apply this equation to the following term:
      length (map f xs) 
    where 
      length xs = fold count 0 xs 
      count x n = 1 + n 
      map f xs = fold (cons . f) [] xs 
(3) Describe why applying this equation as a rewrite 
    during compilation can result in more performant code. 

-} 
