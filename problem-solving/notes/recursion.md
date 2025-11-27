# 🧩 Recursion and Advanced Problem Patterns — Complete Roadmap

---

## **1. Basic Recursion**

### **What**

A function that calls itself with smaller input until reaching a _base case_.  
Used in problems that naturally reduce in size — factorial, Fibonacci, etc.

### **Key Idea**

Every recursive call simplifies the problem → base case stops infinite loop.

### **Example Question**

**Factorial Trailing Zeroes**

> Find the number of trailing zeros in the factorial of a number.  
> LeetCode: [Factorial Trailing Zeroes](https://leetcode.com/problems/factorial-trailing-zeroes/)

---

## **2. Tail Recursion**

### **What**

A special form of recursion where the recursive call is the _last_ operation in the function.  
Optimized by some compilers (or by hand in Python/Java) to reuse stack space.

### **Key Idea**

No further computation after the recursive call → can be converted to iteration.

### **Example Question**

**Convert Sorted List to Binary Search Tree**

> Convert a sorted linked list to a height-balanced binary search tree.  
> LeetCode: [Convert Sorted List to BST](https://leetcode.com/problems/convert-sorted-list-to-binary-search-tree/)

---

## **3. Divide and Conquer**

### **What**

Breaks a big problem into smaller independent subproblems, solves them recursively, then combines results.

### **Key Idea**

Split → Solve → Combine  
Common in sorting, searching, and computational geometry.

### **Example Questions**

- **Merge Sort (Sort an Array)**  
    LeetCode: [Sort an Array](https://leetcode.com/problems/sort-an-array/)
    
- **Find Kth Largest Element in an Array**  
    LeetCode: [Kth Largest Element in an Array](https://leetcode.com/problems/kth-largest-element-in-an-array/)
    

---

## **4. Backtracking**

### **What**

Try building a solution step-by-step. If a path fails, backtrack and try another.

### **Key Idea**

Used in constraint satisfaction (like Sudoku, N-Queens).  
Recursive DFS with state rollback.

### **Example Questions**

- **N-Queens**  
    LeetCode: [N-Queens](https://leetcode.com/problems/n-queens/)
    
- **Subset Sum Problem**
    

---

## **5. Dynamic Programming (Memoization)**

### **What**

Stores solutions to subproblems so we don’t recompute them.  
Top-down (memoization) or bottom-up (tabulation).

### **Key Idea**

Recursion + caching = speed boost 🚀

### **Example Questions**

- **Climbing Stairs**  
    LeetCode: [Climbing Stairs](https://leetcode.com/problems/climbing-stairs/)
    
- **Longest Increasing Subsequence**  
    LeetCode: [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/)
    

---

## **6. Tree Traversal**

### **What**

Recursively visiting all nodes in a binary tree (DFS traversal order).

### **Key Idea**

Recursion naturally fits tree structures due to node-based relationships.

### **Example Questions**

- **Binary Tree Inorder Traversal**  
    LeetCode: [Binary Tree Inorder Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)
    
- **Binary Tree Preorder Traversal**  
    LeetCode: [Binary Tree Preorder Traversal](https://leetcode.com/problems/binary-tree-preorder-traversal/)
    

---

## **7. Combinations and Permutations**

### **What**

Generate all possible arrangements or selections of elements using recursion.

### **Key Idea**

At each step → choose or skip → explore both possibilities.

### **Example Questions**

- **Combinations**  
    LeetCode: [Combinations](https://leetcode.com/problems/combinations/)
    
- **Permutations**  
    LeetCode: [Permutations](https://leetcode.com/problems/permutations/)
    

---

## **8. Depth-First Search (DFS)**

### **What**

A traversal method exploring as far as possible along each branch before backtracking.

### **Key Idea**

DFS = recursion-friendly search for graphs/trees.

### **Example Questions**

- **Number of Islands**  
    LeetCode: [Number of Islands](https://leetcode.com/problems/number-of-islands/)
    
- **Course Schedule**  
    LeetCode: [Course Schedule](https://leetcode.com/problems/course-schedule/)
    

---

## **9. Generating Subsets**

### **What**

Recursively generate all subsets of a given list or set.

### **Key Idea**

At every index → two choices: include or exclude element.

### **Example Question**

**Subsets**

> Given an integer array, return all possible subsets.  
> LeetCode: [Subsets](https://leetcode.com/problems/subsets/)

---

## **10. Matrix Recursion**

### **What**

Recursive problems that involve moving through a 2D matrix grid.

### **Key Idea**

Use recursion with boundary checks and visited tracking.

### **Example Questions**

- **Word Search**  
    LeetCode: [Word Search](https://leetcode.com/problems/word-search/)
    
- **Unique Paths**  
    LeetCode: [Unique Paths](https://leetcode.com/problems/unique-paths/)
    

---

## **11. String Manipulation**

### **What**

Recursive handling of string operations — generating, partitioning, or validating strings.

### **Key Idea**

Break string by index or substring → recurse on smaller portions.

### **Example Questions**

- **Palindrome Partitioning**  
    LeetCode: [Palindrome Partitioning](https://leetcode.com/problems/palindrome-partitioning/)
    
- **Generate Parentheses**  
    LeetCode: [Generate Parentheses](https://leetcode.com/problems/generate-parentheses/)
    

---

## **12. Knapsack Problem**

### **What**

Classic optimization problem solved via recursion + DP.  
Choose items to maximize value without exceeding weight limit.

### **Key Idea**

Include or exclude an item → take the max value.

### **Example Question**

**0/1 Knapsack Problem**

> Solve using recursion or DP (Top-down with memoization).

---

## **13. Graph Algorithms**

### **What**

Recursion is heavily used in graph traversal and processing.

### **Key Idea**

DFS for exploring nodes, recursion for rebuilding structures (like cloning).

### **Example Questions**

- **Clone Graph**  
    LeetCode: [Clone Graph](https://leetcode.com/problems/clone-graph/)
    
- **Minimum Height Trees**  
    LeetCode: [Minimum Height Trees](https://leetcode.com/problems/minimum-height-trees/)
    

---

## **14. Recursive Descent Parsing**

### **What**

Used in compilers to parse mathematical or logical expressions.  
Each grammar rule → recursive function.

### **Key Idea**

Parse expressions recursively by operator precedence.

### **Example Question**

**Basic Calculator**  
LeetCode: [Basic Calculator](https://leetcode.com/problems/basic-calculator/)

---

## **15. Breadth-First Search (BFS) with Recursion**

### **What**

Although BFS typically uses a queue, it can be expressed recursively via level-by-level traversal.

### **Key Idea**

Recursion per level → combine child levels recursively.

### **Example Question**

**Binary Tree Level Order Traversal**  
LeetCode: [Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/)

---

