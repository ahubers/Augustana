from functools import partial 

def fib(n): 
    match n:
      case 0:
          return 1 
      case 1: 
          return 1 
      case _:
        return fib(n - 1) + fib(n - 2)

def sum(xs):
   match xs:
      case []:
         return 0
      case [x , *xs]:
         return x + sum(xs)

def checkTrue(bs):
   match bs:
      case []:
         return False 
      case [x , *xs]:
         return x or checkTrue(xs)

def fold(f , e , xs):
   match xs:
      case []:
         return e
      case [x , *xs]:
         return f(x, fold(f , e , xs))

ssum = partial(fold , lambda x, y: x + y, 0)

prod = partial(fold, lambda x, y: x * y, 1)

anyTrue = partial(fold , lambda x, y: x or y, False)

allTrue = partial(fold , lambda x, y: x and y, True)

length = partial(fold , lambda x, y: y + 1, 0)

def cons(x , xs):
   return [x] + xs

def snoc(x, xs):
   return fold(cons, [x], xs)

reverse = partial(fold, snoc, [])

# filter = partial(fold, lambda  x, y: if )

print(reverse([1, 2, 3]))