package Talk.Demo;

// - Arrays Good! but...
//   drawback: fixed length. :(
// A fix: *dynamically* sized arrays.

// To introduce ArrayLists, I want to take
// a brief stab at their implementation.
// Why?
//   - the particular implementation should become more important
//     later on in this course.
//   - You should be thinking about how classes can be used for
//     "encapsulation"
// Also: it's a good exercise to try the naive approach first!

// So: we want to implement a list class that has an "add" method.
// Specification:
//   - Can add an element to end of list.
public class ArrayListDemo {

    // internally:
    private int[] list;
    // also keep track of occupancy of array:
    private int size = 0;

    // constructor
    ArrayListDemo(int i) {
        this.list = new int[i];
    }
    
    // Simple Interface: add an integer to the list.
    // Remember: ~~naive approach!~~
    // Million dollar question: how can we fix this?
    // - Detect when array is full
    // - Allocate a bigger array, copy elements over
    // That's the basic idea!
    public void add(int x) {
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
        // let's test it out
        ArrayListDemo l = new ArrayListDemo(1); 

        System.out.println(l);

        l.add(1);
        System.out.println(l);

        // what now?
        l.add(1);
    }
}
