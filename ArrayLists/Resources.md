# Plan & ideas
- Maybe start the lecture by implementing an ArrayList and its member methods.
  Weave in comparisons to python lists. 
- I would like to gradually lead students to ArrayLists.  For example,
expose the interface, but notice that when we want to add a new item past the 
bounds of the array, we must allocate more memory. Maybe only do this part during
the introduction to ArrayLists, as I can't talk about other features of its implementation
(Java generics; comparisons to linked lists, etc...)

## Ideas for "code for an application using an ArrayList of some custom data type (not a built-in class like Strings or Integers) to do something useful interesting."

- Song playlist manager
- Maintaining a list of students, Magic the gathering cards...Maybe let students decide?

# Resources

- Sedgewick and Wayne barely talk about array lists, but pg 563 does introduce
  a dynamic length stack implemented as an array list. 
- W3schools: https://www.w3schools.com/java/java_arraylist.asp
- Java documentation: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html

# Interface

```java
add(value),
add(index, value), 
size(), 
get(value), 
indexOf(value), 
set(index, value), 
remove(index),
remove(value), 
clear()
```

Compare this with the syntax of equivalent operations in Python and give examples of each. 