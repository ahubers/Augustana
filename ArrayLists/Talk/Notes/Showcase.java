
// 1. First we need to import the ArrayList class;
import java.util.ArrayList;

public class Showcase {
    
    public static void main(String[] args) {
        // ------------------------------------------------------------
        // 1. First we are going to make an ArrayList.
        //    We use the angled brackets to specify that this is a list 
        //    of strings.

        ArrayList<String> list = new ArrayList<>();

        // ------------------------------------------------------------
        // 2. We can add values to the list:
        // Python: lst.append(value)
        list.add("apple");
        list.add("banana");
        System.out.println("after add(apple) and add(banana): " + list);


        // ------------------------------------------------------------
        // 3. We can also *insert* a value at a specific index.
        //    SAY: Note this means we smush it into the list, 
        //         we don't replace the entry. 
        // Python: lst.insert(index, value)
        
        list.add(1, "orange");
        System.out.println("after add(1, orange): " + list);


        // ------------------------------------------------------------
        // 4. We can ask for the size of the list
        // Python: len(lst)
        // ------------------------------------------------------------
        int size = list.size();
        System.out.println("size(): " + size);


        // ------------------------------------------------------------
        // 5. We can get an element of the list by its index. 
        // Python: lst[index]
        // ------------------------------------------------------------
        String item = list.get(0);
        System.out.println("get(0): " + item);


        // ------------------------------------------------------------
        // 6. We can get the index of a value in the list
        // Python: lst.index(value)
        // (Python throws ValueError if not found; Java returns -1)
        // ------------------------------------------------------------
        int idx = list.indexOf("banana");
        System.out.println("indexOf(banana): " + idx);


        // ------------------------------------------------------------
        // 7. We can specify the value at a given index. 
        // SAY: Note this will *replace* that value!

        // Python: lst[index] = value
        // ------------------------------------------------------------
        list.set(1, "kiwi");
        System.out.println("After set(1, kiwi): " + list);


        // ------------------------------------------------------------
        // 8. We can remove a value at a given index
        // Python: lst.pop(index)
        // ------------------------------------------------------------
        list.remove(0);
        System.out.println("After remove(0): " + list);


        // ------------------------------------------------------------
        // 9. We can remove a given value
        // SAY: Note that this is the same method name but different
        //      behavior!
        // Python: lst.remove(value)
        // (Python removes first matching value; Java does the same)
        // ------------------------------------------------------------
        list.remove("kiwi");
        System.out.println("After remove(kiwi): " + list);


        // ------------------------------------------------------------
        // 10. And finally we can wipe the slate clean using clear():
        // Python: lst.clear()
        // ------------------------------------------------------------
        list.clear();
        System.out.println("After clear(): " + list);

    }
}
