package Demo;
// 1. Arrays vs. ArrayLists. 

public class ArrayListDemo {

    private int[] xs = new int[1]; 
    private int size = 0;

    // Append an integer to the list.
    public void add(Integer x) {
        xs[size] = x;
        size++;
    }

    public static void main(String[] args) {

        ArrayListDemo list = new ArrayListDemo();
        list.add(1);
        list.add(2);
    }
}
