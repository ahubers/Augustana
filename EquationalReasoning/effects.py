
import math 

# Sales tax function
def salesTax(n):
    return n * 1.07

# floor function
def floor(n):
    return math.floor(n)

# map, as a list comprehension
def map(f, xs):
    return [f(x) for x in xs]

# Map fusion examples
# --------------------

items = [20.0 , 35.0 , 50.0]

# Option 1:
#   map (floor (map salesTax items))
opt1 = map(floor, map(salesTax, items))
print("Option 1: ")
print(opt1)


# Option 2:
#   map (floor . salesTax) items
def floor_salesTax(x):
    return floor(salesTax(x))

opt2 = map(floor_salesTax, items)
print("Option 2: ")
print(opt2)
