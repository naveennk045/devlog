
### Multi threading


By default, a computer executes instructions **sequentially** (one after another). As you noted, this is slow. If one task gets stuck (e.g., waiting for a network download), the entire program freezes, leading to high **latency** and a poor user experience.

**Multithreading** is a solution that allows a single program to do multiple things at once, using the concepts of concurrency and parallelism.

---

### 2. The Concepts: Concurrency vs. Parallelism

#### Concurrency (One Chef, Great Planning) 🧑‍🍳

- **Analogy :** A single chef in a kitchen plans their work. While the water boils, they cut vegetables. While the rice boils, they prepare sweets.
    
- **Technical Definition:** Concurrency is about **managing** multiple tasks at the same time. On a single-core CPU, this is an _illusion_ of simultaneous execution. The CPU rapidly **switches** between tasks (this is called _context switching_). At any given nanosecond, only one task is _actually_ running.
    
- **Key Concept:** "Dealing with" many things at once.
    

#### Parallelism (Multiple Chefs, More Output) 🧑‍🍳🧑‍🍳🧑‍🍳

- **Analogy :** There are multiple chefs in the kitchen, and they _all_ work on different tasks at the exact same time.
    
- **Technical Definition:** Parallelism is about **doing** multiple tasks at the exact same time. This is _true_ simultaneous execution.
    
- **Key Concept:** This is only possible with hardware that has multiple processing units, like a **multi-core CPU**.
    

---

### 3. The Building Blocks: Program, Process, & Thread

Your notes on Program and Process are correct. The missing link is **Thread**.

- **Program (The Recipe):** A passive file on your hard drive containing a set of instructions (e.g., `Chrome.exe`).
    
- **Process (The Restaurant):** An active instance of a program that is running. The operating system gives it a private, isolated block of memory and resources. It's the "restaurant" itself, with its own kitchen and ingredients.
    
- **Thread (A Chef in the Restaurant):**
    
    - This is the _actual_ unit of execution that runs the code.
        
    - A process starts with one main thread (one chef).
        
    - **Multithreading** is when that process creates _more_ threads (hires more chefs).
        
    - All threads _inside_ a process **share the same memory** (all chefs work in the same kitchen, using the same ingredients). This makes them fast to communicate but also dangerous, as one "chef" can spoil the "ingredients" (memory) for all the others.
        

---

### 4. The Mechanism: Time Slicing Algorithm

This is the concept that makes **concurrency** work on a single-core CPU.

- **What it is:** The **Time Slicing Algorithm** (also called Round Robin scheduling) is the OS's rule for faking parallelism.
    
- **How it works:**
    
    1. The OS gives each thread (or process) a small, fixed "time slice" (e.g., 20 milliseconds).
        
    2. Thread A runs for its 20ms.
        
    3. The OS forcibly pauses Thread A (saving its state) and switches to Thread B.
        
    4. Thread B runs for its 20ms.
        
    5. It repeats this cycle for all threads, switching so fast it _appears_ they are all running at the same time.

----
### 5. Advantages and Disadvantages

- **Advantages:**
    
    - **Responsiveness:** Keeps an application (especially with a UI) from freezing. A "UI thread" can remain responsive while "worker threads" do heavy tasks in the background.
        
    - **Efficiency:** Threads are "lightweight." They are faster to create, switch between, and use fewer resources than starting a whole new process.
        
    - **Resource Sharing:** All threads in a process share the same memory, making it very easy and fast to share data between them.
        
- **Disadvantages:**
    
    - **High Complexity:** This is the biggest drawback. You must manage all the threads yourself, leading to...
        
    - **Synchronization Problems:** When multiple threads try to read and write to the same shared memory, you get major errors:
        
        - **Race Conditions:** The result depends on which thread "wins the race" to write data first, leading to unpredictable behaviour.
            
        - **Deadlocks:** Thread A is waiting for a resource held by Thread B, but Thread B is waiting for a resource held by Thread A. Both are frozen forever.
            
    - **Hard to Debug:** These errors can be intermittent and extremely difficult to reproduce, making them a nightmare to find and fix.