module EquationalReasoning where
import Data.Char (toUpper)
import Prelude hiding 
  (sum, concat, length, map, repeat, sqrt, filter, any, all, const, succ, reverse, unlines , negate)

{- -----------------------------------------------------------------------------
Talk for Augustana College, Weds Feb 25, 2026
Alex Hubers, University of Iowa
--------------------------------------------------------------------------------
-- (1) introduction.

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
## How are mathematical functions different from programming language functions?
Possible answers:
- A math function always takes the same input to the same output (deterministic)
  - aka, no randomness / probability
  - Must return an output!
- Other "side effects":
  - Mutable state
  - Exceptions
  - Reading input & writing output

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

-- >>> x + 2
-- 4

--------------------------------------------------------------------------------
-- (2) referential transparency

-- SAY:
-- First let's talk about why function purity can be desirable.
-- (open Counter.py)
-- (C-c C-c to load python code to repl.)
{- 
```py  
counter = 0 

def inc(x):
    global counter
    counter += 1
    return x + counter 

print(inc(10))
print(inc(10))
```
-}

-- Question: Can I replace inc(10) with 11 everywhere in my code? 
--           No. 
-- SAY:
-- inc relies on hidden mutable state, meaning it is not a mathematical function:
-- Write:
-- We have:
--    inc(10) = 11
--    inc(10) = 12
-- therefore:
--    inc(10) != inc(10)

--------------------------------------------------------------------------------
-- 3. Haskell functions & equational reasoning (5 minutes)
-- SAY:
-- Functions in Haskell are written equationally, with inputs 
-- on the LHS and outputs on the RHS. 

-- SAY:
-- For example, this function applies a 7% sales tax to its input:
salesTax n = 1.07 * n

-- SAY:
--   For the purpose of illustration, let's suppose 
--   we have a list of items in some purchase. 
items = [20.0 , 35.0 , 50.0]

-- SAY:
--   Let's apply the sales tax to each item. 
salesTaxAll []       = [] 
salesTaxAll (x : xs) = salesTax x : salesTaxAll xs
--           ^   ^                  
--        head   tail             
{- SAY:
  # Recursion does not have to be scary!
  SAY:
    We don't have call frames or stacks of environments with this sort of recursion.
    We can think about this recursion with a "copy and paste" mindset.
    For example: 
  WRITE:
    salesTaxAll (1 : 2 : [])
    SAY:
      The key insight is we can "rewrite" by the equations above.
      We "match" on the second equation.
  = salesTax 1 : (salesTaxAll (2 : []))
    {Apply snd equation again}
  = salesTax 1 : salesTax 2 : (salesTaxAll [])
    {Apply first equation}
  = salesTax 1 : salesTax 2 : []
  = [salesTax 1, salesTax 2]

WRITE:
This is called *equational reasoning*. 

SAY:
Equational reasoning makes program behavior easier to predict, 
analyze, optimize, and verify. We can use equational reasoning to
- prove program correctness 
- derive and implement optimizations
Equational reasoning is also the fundamental basis for interactive
theorem proves such as Lean, Roq, and Agda.

SAY: 
Moving on, let's see how this function works on `items`.

-- >>> salesTaxAll items
-- [21.400000000000002,37.45,53.5]
 -} 

-- SAY: 
--   Because I'm a discrete mathematician, I am uncomfortable with floating point
--   precision. 
--   Let's just suppose that we have run out all coin change at our store,
--   and so we're going to round down each item. 
-- >>> floor 1.23
-- 1

-- SAY:
--   Let's apply that to every element of the list:
floorAll [] = [] 
floorAll (x : xs) = floor x : floorAll xs 

-- The final result:
-- >>> floorAll (salesTaxAll items)
-- [21,37,54]

--------------------------------------------------------------------------------
-- Mapping 

-- SAY:
-- QUESTION: What is the only change we've made between salesTaxAll and floorAll?
-- COPY PASTE FOR REFERENCE:
--   salesTaxAll []       = [] 
--   salesTaxAll (x : xs) = salesTax x : salesTaxAll xs
--   floorAll    []       = [] 
--   floorAll    (x : xs) = floor x    : floorAll xs 
-- A: We replaced "salesTax" with "floor".

-- SAY:
-- Let's abstract the structure of these two functions. 
-- We will do so by using a *higher-order* function. 
-- DO IN REAL TIME: 
-- 0. start with def'n of floorAll
-- 1. Rename floorAll to map
-- 2. add f as input 
-- 3. replace floor with f 
--   floorAll    []       = [] 
--   floorAll    (x : xs) = floor x : floorAll xs 

map f []       =  [] 
map f (x : xs) = f x : map f xs 

-- SAY:
-- Now we can reimplement our functions using map. 
-- >>> map salesTax items
-- [1.07,2.14,3.21]

-- >>> map floor items
-- [1,3,4]

-- WRITE:
--   In general, we can use equational reasoning to show that:
--   map f [x1 , ... , xn ] = [f x1 , ... , f xn]

--------------------------------------------------------------------------------
-- We next need to talk about *function composition*

-- WRITE: 
-- Function composition is written (f . g) and defined by
--   (f . g) x = f (g x)

-- SAY: 
--   For example,
-- (floor . salesTax) x = floor (salesTax x)

-- SAY:
-- What we have right now is:
-- >>> floorAll (salesTaxAll items)
-- [1,2,4]

-- Which can be rewritten to:

-- >>> map floor (map salesTax items)
-- [1,2,4]

-- SAY: Interestingly, we can show this function is equivalent
--      to the map of a composed function. This is called
--      the "map fusion" law.
{- WRITE: 

## Map fusion law 
  map (f . g) [x1 , ... , xn] = map f (map g [x1 , ... , xn]
e.g. 
  map (floor . salesTax) items = map floor (map salesTax items)

WRITE:
We will use the following identity:
  map h [y1 , ... , yn] = [h y1 , ... , h yn]  (equation 1)
SAY:
  Let's call this "Equation 1".

START WITH:
    map (f . g) [x1 , ... , xn]
  = ...
  = map f (map g [x1 , ... , xn])
SAY:
  We need to fill in the middle. 

Answer:
  map (f . g) [x1 , ... , xn]
  SAY: First apply equation (1)
= [ (f . g) x1 , (f . g) x2 , ... , (f . g) xn ]  
  SAY: Now expand the definition of composition. 
= [ f (g x1) , ... , f (g xn) ]
   SAY: Any ideas on what to do next?
   ANSWER: Use equation (1) in the right-to-left direction. 
= map f [g x1 , ... , g xn ]
  SAY: Do the same again. 
= map f (map g [x1 , ... , xn])

(2) QUESTION: Which program is more efficient? 
      map (f . g) [x1 , ... , xn]
    or 
      map f (map g [x1 , ... , xn])

Answer: 
  The first one only iterates over the list once, and so 
  is more efficient.

    SAY:
(3) QUESTION: 
    (1) Describe how a compiler might optimize code that includes
        nested map expressions, and  
    (2) Argue why your proposed optimization 
        would not interfere with the program's meaning.
Answer: 
  A compiler could rewrite subexpressions of the form map f (map g xs)
  to map (f . g) xs. This would not interfere with the program's meaning 
  because the functions f and g are pure and hence referentially transparent.
  This optimization eliminates intermediate lists and reduces runtime. 

(4) Finally, would this be true in Python?

-} 

------------------------------------------------------------------------------
{- Conclusion 

SAY: Programming with pure functions gives us:
     - clearer, more predictable code
     - correctness proofs 
     - potential optimizations 
    
    If there is time for questions I would love to answer them.
-}


--------------------------------------------------------------------------------
-- CUT 1

-- WRITE:
-- In general, we can show that:
--   map f [x1 , x2 , ... , xn] = [f x1 , f x2 , ... , f xn]
-- Proof:
--   map f (x1 : x2 : ... : xn : [])
--     SAY: The key insight is that we may "rewrite" by 
--          the equations of `map` in this term. 
--     QUESTION: Which equation applies here?
--    {Apply second equation}
--  = f x1 : map f (x2 : ... : xn : [])
--    SAY: now we repeat this process.
--  = f x1 : f x2 : (map f (... : xn : []))
--  = f x1 : f x2 : ... : f xn : map f []
--                               --------
--    QUESTION: now which equation applies?
--  = f x1 : f x2 : ... : f xn : [] 
--  = [f x1 , f x2 , ... , f xn]

--------------------------------------------------------------------------------
-- CUT 2

-- SAY:
-- Before we finish I would like to showcase a more sophisticated
-- example.  

-- SAY:
-- To make things easier to read, define `cons` as a function 
-- that adds an element to the front of a list. 
cons x xs = x : xs 

-- >>> cons 1 [2, 3]
-- [1,2,3]

-- SAY: 
-- Here's a definition I've always loved. I encourage you all to try 
-- to write a powerset function of your own---it's surprisingly tricky. 
-- (Don't worry about understanding this definition fully.)
powerset []       = [[]]
powerset (x : xs) = map (cons x) (powerset xs) ++ powerset xs

-- >>> powerset [1, 2, 3]
-- [[1,2,3],[1,2],[1,3],[1],[2,3],[2],[3],[]]
