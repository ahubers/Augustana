
counter = 0 

def inc(x):
    global counter
    counter += 1
    return x + counter 

def map(f, xs):
    return [ f x for x in xs ]