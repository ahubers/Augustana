
package Demo;
// First we need to import the ArrayList class;
import java.util.ArrayList;

public class Showcase {
    
    public static void main(String[] args) {
        // 1. We can make a list! of strings!
        ArrayList<String> list = new ArrayList<>();

        // 2. We can add things to the list
        // in python: list.append()
        list.add("apple");
        list.add("banana");
        System.out.println("after add(apple) and add(banana): " + list);

        // 3. We can insert a value at a specific index
        // in python: list.insert(index, value)
        list.add(1, "orange");
        System.out.println("after add(1, orange): " + list);

        // 4. We can get the size of the list!
        // Python: len(list)
        int size = list.size();
        System.out.println("size(): " + size);
        
        // 5. We can get an element by its index
        // in Python: lst[index]
        String item = list.get(0);
        System.out.println("get(0): " + item);

        // 6. We can ge tthe index of a value in the list 
        int idx = list.indexOf("banana");
        System.out.println("indexOf(banana): " + idx);

        // 7. We can specify the value at a given index:
        //    Note: this will *replace* that value!
        list.set(1, "kiwi");
        System.out.println("After set(1, kiwi): " + list);

        // 8. We can remove a value at a given index!
        // in python: list.pop(index)
        list.remove(0);
        System.out.println("After remove(0): " + list);

        // 9. in python: list.remove(value)
        list.remove("kiwi");
        System.out.println("After remove(kiwi): " + list);

        // 10. We can wipe the slate clean!
        // Python: list.clear()
        list.clear();
        System.out.println("After clear(): " + list);


    }
}