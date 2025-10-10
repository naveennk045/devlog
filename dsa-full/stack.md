
### Core Concept of a Stack
A **stack** is a Last-In-First-Out (LIFO) data structure. The core operations are:
*   `push(item)`: Add an item to the top.
*   `pop()`: Remove and return the top item.
*   `peek()` / `top()`: Return the top item without removing it.
*   `isEmpty()`: Check if the stack is empty.

This simple structure is incredibly powerful for solving problems where you need to "remember" the most recent element in a sequence.

---

### Fundamental Patterns & Techniques

#### 1. Last-In-First-Out (LIFO) Processing
This is the most basic use case. You use a stack when the order of processing needs to be the reverse of the order of arrival.
*   **Example:** Reversing a string, a list, or a linked list.
*   **Problem:** "Reverse a string using a stack."

#### 2. Matching & Validation (The Classic Use Case)
Stacks are perfect for validating nested structures because you need to match the most recent opening symbol with the next closing symbol.
*   **Key Insight:** Push opening symbols. When you find a closing symbol, pop from the stack and check if they form a valid pair.
*   **Classic Problems:**
    *   **Valid Parentheses (`(`, `)`, `{`, `}`, `[`, `]`)**: The quintessential stack problem.
    *   **Valid HTML/XML Tags**: Similar to parentheses but with tags like `<div>` and `</div>`.
    *   **Simplify File Path** (e.g., `/a/./b/../../c/` becomes `/c`): Use a stack to simulate directory navigation.

#### 3. Next Greater/Smaller Element (Monotonic Stack Pattern)
This is one of the most important and common patterns. The goal is to find the next element in an array that is greater (or smaller) than the current element.
*   **Key Insight:** Use a **Monotonic Stack** (a stack where elements are in a specific order, e.g., strictly decreasing).
    *   **For "Next Greater Element"**: Maintain a *monotonically decreasing* stack.
    *   **For "Next Smaller Element"**: Maintain a *monotonically increasing* stack.
*   **Algorithm (Next Greater Element):**
    1.  Iterate through the array from left to right (or right to left, depending on the problem).
    2.  While the stack is not empty and the current element is greater than the element at the top of the stack:
        *   `pop()` from the stack. The "next greater element" for the popped element is the current element.
    3.  `push()` the current element's index onto the stack.
*   **Variations of this Pattern:**
    *   **Next Greater Element I & II** (II is a circular array)
    *   **Daily Temperatures** ("How many days until a warmer day?")
    *   **Largest Rectangle in Histogram** (This is the master problem for this pattern)
    *   **Sliding Window Maximum** (Can be solved with a Monotonic Queue, which is closely related).

#### 4. Evaluating Expressions
Stacks are naturally suited for evaluating expressions because they handle operator precedence and nested parentheses.
*   **Infix to Postfix/Prefix Conversion:** You need two stacks (or one stack and one output list): one for operators and one for operands.
*   **Direct Evaluation:**
    *   **Postfix Evaluation (Reverse Polish Notation):** Very straightforward. Push numbers. On an operator, pop the top two numbers, apply the operator, push the result back.
    *   **Infix Evaluation:** More complex. Requires two stacks (values and operators) and rules for handling precedence.

#### 5. Depth-First Search (DFS) on Graphs and Trees
A stack is the fundamental data structure used to implement **iterative DFS**. You use it to keep track of the path from the root to the current node.
*   **Tree DFS:** Push the root. While the stack is not empty, `pop()` a node, process it, and `push()` its children (right first, then left for pre-order).
*   **Graph DFS:** Same idea, but you also need a `visited` set to avoid cycles.
*   **Problems:** All DFS-based traversals (Pre-order, In-order, Post-order iteratively), finding connected components, pathfinding.

#### 6. Simulation & Undo Functionality
Stacks can be used to simulate a process and "backtrack" or "undo" actions.
*   **Problem: Remove All Adjacent Duplicates In String** (e.g., "abbaca" -> "ca"): Push characters. If the top matches the current character, pop instead of pushing.
*   **Problem: Make The String Great** (similar to above but with case sensitivity).
*   **Problem: Design a Stack With Increment Operation** (simulate the operations).
*   **Browser Back/Forward Button:** Two stacks (one for back history, one for forward history).

---

### Advanced Patterns & Techniques

#### 7. Tracking the Minimum/Maximum in a Stack
How to design a stack that supports `push`, `pop`, and `getMin` (or `getMax`) in constant time, O(1).
*   **Key Insight:** Use two stacks: one for the main data and one to track the current minimum/maximum at every corresponding level of the main stack.
*   **Problem: Min Stack**

#### 8. Stock Span Problem & Its Variants
This is a direct application of the "Next Greater Element" pattern, looking backwards.
*   **Problem:** The stock span `S[i]` is the number of consecutive days before day `i` where the price was less than or equal to today's price.
*   **Solution:** Use a monotonic stack (decreasing order) to find the previous greater element. The span is `i - stack.top() - 1`.

#### 9. Managing Recursion (The Call Stack)
This is what happens under the hood in programming languages. Any recursive function can be converted to an iterative one using an explicit stack. This is useful to avoid recursion depth limits.
*   **Problem: In-order Traversal of a BST (Iterative)**
*   **Problem: Decode String** (e.g., `"3[a2[c]]"` -> `"accaccacc"`): You often need two stacks—one for counts and one for strings—to simulate the nested recursion.

#### 10. The "Mountain" or "Valley" Pattern
Problems that involve finding peaks or troughs in sequences can often be solved by analyzing the elements popped from a monotonic stack.
*   **Problem: Trapping Rain Water:** For each bar, the water it can trap is determined by the first higher bars to its left and right. A monotonic stack (decreasing) is perfect for finding these boundaries.
*   **Problem: Asteroid Collision:** Simulate the collisions. Push moving-right asteroids. When a moving-left asteroid appears, it will collide with the top of the stack (if it's moving right). Use the stack to simulate the outcomes.

---

### How to Practice Effectively

1.  **Start with the Basics:** Master "Valid Parentheses" and "Min Stack". Understand them inside and out.
2.  **Tackle the Monotonic Stack:** This is the big one. Solve "Next Greater Element", then "Daily Temperatures", and finally challenge yourself with "Largest Rectangle in Histogram". This pattern is incredibly common in interviews.
3.  **Practice Expression Evaluation:** Implement a simple RPN calculator. Then try the infix to postfix conversion.
4.  **Simulate and Backtrack:** Solve the "Remove Adjacent Duplicates" problems. They are simple but teach you the simulation mindset.
5.  **Iterative DFS:** Pick a tree problem you know how to solve recursively (like counting nodes) and force yourself to write the iterative version using a stack.
6.  **Conquer the Classics:** Move on to the harder problems like "Trapping Rain Water" and "Asteroid Collision".

### Classic Problem List for Practice

| Problem Name | Key Pattern |
| :--- | :--- |
| 1. Valid Parentheses | Matching & Validation |
| 2. Min Stack | Tracking Min/Max |
| 3. Reverse a String/List | LIFO Processing |
| 4. Next Greater Element I | Monotonic Stack |
| 5. Daily Temperatures | Monotonic Stack |
| 6. Largest Rectangle in Histogram | **Master Problem** (Monotonic Stack) |
| 7. Evaluate Reverse Polish Notation | Expression Evaluation |
| 8. Remove All Adjacent Duplicates In String | Simulation & Backtrack |
| 9. Asteroid Collision | Simulation & Monotonic Stack |
| 10. Trapping Rain Water | Monotonic Stack / Two Pointers |
| 11. Binary Tree Inorder Traversal (Iterative) | Iterative DFS |
| 12. Decode String | Simulation / Recursion with Stack |
| 13. Simplify Path | Stack for Simulation |
| 14. Implement Queue using Stacks | Using stacks to achieve FIFO |
| 15. Implement Stack using Queues | Using queues to achieve LIFO |
| 16. Stock Span Problem | Monotonic Stack (Previous Greater) |
| 17. The Celebrity Problem | Elimination using Stack |
| 18. Maximum Frequency Stack | Stack + Hash Map (Advanced) |

By working through these patterns and problems, you will develop a strong intuition for when and how to use a stack, making you a much more effective problem solver. Good luck


