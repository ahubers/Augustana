// 1. Arrays are a great data structure. What is one limitation?
//    They have a *fixed* size. But do we always know how many
//    things we want to store?
//
//    Let's illustrate the idea behind a *dynamically sized* array.

public class ArrayListDemo {

    // 2. Internal representation:
    //    - xs: the backing array
    //    - size: how many elements are actually stored
    private int[] xs = new int[1];
    private int size = 0;

    // 3. Append an integer to the list.
    public void add(int x) {
        // PROBLEM: what if size == xs.length?
        xs[size] = x;
        size++;
    }

    public static void main(String[] args) {
        ArrayListDemo list = new ArrayListDemo();

        list.add(1);   // fine
        list.add(2);   // crash: array out of bounds!

        // Ask class: How can we fix this?
        // 5. The fix (conceptually):
        //    - detect when array is full
        //    - allocate a bigger one
        //    - copy elements over
        //
        //    This is exactly what Java's ArrayList does internally.
    }
}
