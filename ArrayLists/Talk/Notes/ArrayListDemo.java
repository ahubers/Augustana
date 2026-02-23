// SAY: 
//   Arrays are a great data structure with one annoying limitation: we have to specify
//   the size ahead of time.
// QUESTION: Do we always know how big of an array we will need?
// A: No! Many applications and algorithms require a *dynamically sized* array.
//    ArrayLists are (one of) Java's answers to this problem.

// SAY:
//   I want to talk a bit about implementation because:
//   1. it will become important later in the course when discussing 
//      linked lists and computational efficiency
//   2. An important aspect of OOP is abstraction & implementation hiding.

// SAY:
//   Our specification: implement a list class that has an "add" method.
public class ArrayListDemo {

    // Under the hood, We will store data in an array
    private int[] list = new int[1];
    // And keep track of how many elements are in the array
    private int size = 0;

    // Interface: add an integer to the list.
    public void add(int x) {
        // PROBLEM: what if size == xs.length?
        list[size] = x;
        size++;
    }

    // (hideme)
    public String toString() {
        if (size == 0) {
            return "[]";
        }

        if (size == 1) {
            return "[" + list[0] + "]";
        }

        String s = "[";
        for (int i = 0; i < size; i++) {
            s += list[i] + ", ";
        }
        s += "]";
        return s;
    }

    public static void main(String[] args) {
        ArrayListDemo l = new ArrayListDemo();

        // empty list
        System.out.println(l);

        // singleton list
        l.add(1); 
        System.out.println(l);

        // crash: array out of bounds!
        l.add(2);   

        // Ask class: How can we fix this?
        // 5. The fix (conceptually):
        //    - detect when array is full
        //    - allocate a bigger one
        //    - copy elements over
        //
        //    This is exactly what Java's ArrayList does internally.
    }
}
