
package Talk.Demo;
// First we need to import the ArrayList class;
import java.util.ArrayList;

public class Showcase {
    
    public static void main(String[] args) {
    // showcase! What can we do with Arraylists?

    // 1. Initialize an ArrayList of strings
    ArrayList<String> list = new ArrayList<>();
    //          ^                         ^
    //    type of contents               can omit over here

    // 2. Can add values to the list
    // in Python: list.append(value)
    list.add("apple");
    list.add("banana");
    System.out.println("after add(apple) and add(banana): " + list);

    // 3. Can "insert" at a specific index
    // Python: list.insert(index, value)
    list.add(1, "orange");
    System.out.println("after add(1, orange): " + list);
    // should print [apple, orange, banana]

    // 4. We can get the size of the list
    // Python: len(list)
    int size = list.size();
    System.out.println("size() : " + size);
    // should print? 3.

    // 5. We can get an element of the list by its index
    // Python: lst[index]
    System.out.println("get(0): " + list.get(0));
    // should print? "apple"

    // 6. We can get the index of a value in the list
    // Python: list.index(value)
    int idx = list.indexOf("banana");
    System.out.println("indexOf(banana): " + idx); 
    // should print? 2 

    // 7. We can specify the value at a given index
    // (replaces that value!)
    // python: list[index] = value 
    list.set(1, "kiwi");
    System.out.println("After set(1, kiwi): " + list);
    // should print? [apple, kiwi, banana]

    // 8. We can remove a value at a given index
    // Python: list.pop(index)
    list.remove(0);
    System.out.println("After remove(0): " + list);
    // should print? [kiwi, banana]

    // 9. Can remove a given value (by that value)
    // Python: list.remove(value)
    list.remove("kiwi");
    System.out.println("After remove(kiwi): " + list);
    // should print? [banana]

    // 10. Finally--- we can wipe the slate clean
    // Python: list.clear();
    list.clear(); 
    System.out.println("After clear(): " + list);
    // should print? []

    // Any questions?

    }
}