# **DSA  – Arrays, Strings, and Core Patterns**

---

## **Arrays & Strings [ Substring and Subarray ]**

### **@ Top 50 Problems in GFG**

> 📘 Reference:  
> [Top 50 Array Problems](https://www.geeksforgeeks.org/top-50-array-coding-problems-for-interviews/)  
> [Top 50 String Problems](https://www.geeksforgeeks.org/top-50-string-coding-problems-for-interviews/)

---

### **Key Topics**

#### **1. Sliding Window & Two Pointers**

- Used for problems involving **contiguous subarrays/substrings**.
- Patterns: fixed-size window, variable-size window, shrinking window.
- Associate with **data structures** like:
    - **Deque** → for window maximum/minimum.
    - **Monotonic Stack** → for next greater/smaller elements.
    - **Priority Queue** → for k-largest/smallest in window.

#### **2. Array Rotation**

- Techniques: reversal algorithm, juggling algorithm, cyclic rotation using modulo.
- Practice both **left and right rotations**.
#### **3. Searching & Sorting**

- Cover: binary search, modified binary search, merge sort-based counting (e.g., inversions).
- Learn `bisect_left()` and `bisect_right()` (Python) for efficient binary search logic.

#### **4. Count of Valid Subarrays / Substrings**

- Use **prefix sum**, **hashing**, or **two pointers**.
- Example: subarray sum = k, count of balanced strings, etc.

#### **5. Shortest & Longest Subarray / Substring**

- Apply **sliding window** or **prefix sum** for shortest length.
- **HashMap** for longest substring without repeating characters, etc.

#### **6. Prefix Sum & Binary Search**

- Prefix sum → range queries, subarray sums, balance counts.
- Combine prefix sum with binary search for cumulative problems (e.g., `find smallest subarray ≥ K`).

---

## **HashMap**

### **@ Frequency-Based Problems**

- Count elements, characters, pairs, or prefix frequencies.
- Examples:
    
    - “Find subarrays with equal number of 0s and 1s”
    - “Group anagrams”
    - “Find duplicates / majority element”

---

## **Greedy Algorithms**

### **Key Focus**

- Relies on **sorting** and **priority queues**.
- Choose locally optimal solution → build towards global optimum.


### **Examples**

- Activity selection, interval scheduling, coin change (non-DP), Huffman coding.
- Use **increasing/decreasing data structures** like min/max heaps.

---

## **Recursion & Backtracking (Basics)**

### **1. Recursion Tree**

- Visualise function calls.
- Understand overlapping sub-problems and repeated calls.

### **2. Variables & Scope**

- Track how **local/global variables** behave in recursion.
- Understand **pass by reference vs. value**.


### **3. Using Return Statement Effectively**

- Decide when to **return values** vs **accumulate results**.

### **4. Types of Recursion**

- Direct, indirect, tail, non-tail.
### **5. Convert Loops → Recursion**

- Helps build **backtracking** intuition. 
- Example: generating subsets, combinations, permutations.

### **# Use Cases by Data Structure**

- **Stack** → recursion stack & undo operations
- **HashMap** → memoization
- **Heap** → [[optimization]] in recursive searches
- **Graph/Tree** → DFS-based recursion
---

## **Reference: GFG Topic-Wise Problem Lists**

|Topic|Link|
|---|---|
|Arrays|[Top 50 Array Interview Questions](https://www.geeksforgeeks.org/top-50-array-coding-problems-for-interviews/)|
|Matrix|[Top 50 Matrix Questions](https://www.geeksforgeeks.org/top-50-matrix-grid-coding-problems-for-interviews/)|
|Strings|[Top 50 String Questions](https://www.geeksforgeeks.org/top-50-string-coding-problems-for-interviews/)|
|Linked List|[Top 50 Linked List Questions](https://www.geeksforgeeks.org/top-50-linked-list-interview-question/)|
|Stack|[Top 50 Stack Questions](https://www.geeksforgeeks.org/top-50-problems-on-stack-data-structure-asked-in-interviews/)|
|Queue|[Top 50 Queue Questions](https://www.geeksforgeeks.org/top-50-problems-on-queue-data-structure-asked-in-sde-interviews/)|
|Tree|[Top 50 Tree Questions](https://www.geeksforgeeks.org/top-50-tree-coding-problems-for-interviews/)|
|Heap|[Top 50 Heap Questions](https://www.geeksforgeeks.org/top-50-problems-on-heap-data-structure-asked-in-interviews/)|
|Graph|[Top 50 Graph Questions](https://www.geeksforgeeks.org/top-50-graph-coding-problems-for-interviews/)|
|Dynamic Programming|[Top 50 DP Questions](https://www.geeksforgeeks.org/top-50-dynamic-programming-coding-problems-for-interviews/)|

---

## **Common LeetCode Patterns**

- Two Pointers
- Topological Sort
- Binary Search, DFS, BFS
- Top-K Elements (Heap / Priority Queue)
- Modified Binary Search
- Subset / Permutation / Combination
- Sliding Window

---

## **Efficient Binary Search in Python**

> Study modules:
> 
> - `bisect_left`
>     
> - `bisect_right`
>  

Used to:

- Find insertion points
- Handle lower/upper bounds efficiently

---

## **Recognizing Problem Clues and Mapping to Approaches**

|**Clue**|**Approach / Technique**|
|---|---|
|“Find the number of …”|Hashing / Prefix Sum / Counting|
|“Longest / Maximum / Minimum …”|Sliding Window / DP / Greedy|
|“Number of ways to …”|DP / Combinatorics / Recursion|
|“All subsets / permutations / combinations”|Backtracking|
|“Subarray / Substring / Slice”|Sliding Window / Prefix Sum / Two Pointers|
|“Sorted Array / Matrix”|Binary Search|
|“Graph / Connection / Reachability”|BFS / DFS / Union-Find|
|“Undo / Reverse / Track history”|Stack|
|“First / Last / Smallest / Largest K items”|Heap (Priority Queue)|
|“Prefix / Suffix Queries”|Prefix Sum / Segment Tree / BIT|
|“Optimal Strategy / Player Wins”|DP + Game Theory|
|“Characters and Frequencies”|HashMap / Counter|
|“Recurrence / Overlapping Subproblems”|DP / Memoization|
|“Multiple Intervals / Merge or Overlap”|Sorting + Two Pointers / Sweep Line|
|“Cycle / SCC (Strongly Connected Components)”|DFS / Tarjan / Union-Find|
|“Online Stream of Data”|Heap / Monotonic Queue / Two Pointers|

---

## **Conclusion & Recommendations**

- 🔹 Start with **Arrays, Strings, and Sliding Window** — these build your intuition for patterns.
- 🔹 Always try **brute force → optimize → optimal** while solving.
- 🔹 Track **time and space complexity** for every approach.
- 🔹 Practice both **GFG and LeetCode pattern-wise**.
- 🔹 Maintain a **pattern-based notebook** (like above) — it’s more valuable than topic-based cramming.
