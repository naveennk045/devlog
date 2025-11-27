
## Overlapping subproblems

**Overlapping subproblems** is a key property of a problem that indicates it can be solved efficiently using **dynamic programming**.1

It means that a problem can be broken down into smaller pieces (subproblems), and that the **same subproblem is encountered and needs to be solved multiple times**.2

A naive recursive approach would solve this same subproblem over and over again, leading to a massive waste of computation and often an exponential time complexity.3 Dynamic programming solves this by storing (or "memoizing") the result of each subproblem the first time it's solved, so any subsequent time it's needed, the solution can be looked up in constant time instead of being re-calculated.4

---

### 🏛️ The Classic Example: Fibonacci Sequence

The most common way to understand this is with the Fibonacci sequence, where `fib(n) = fib(n-1) + fib(n-2)`.5

Let's say you want to calculate **`fib(5)`** using a simple recursive function. Look at how many times the same calculations are repeated:

```
                      fib(5)
                    /        \
               fib(4)          fib(3)
              /      \        /      \
         fib(3)    fib(2)  fib(2)    fib(1)
        /      \  /      \ /      \
    fib(2) fib(1) fib(1) fib(0) fib(1) fib(0)
   /      \
fib(1) fib(0)
```

As you can see:

- **`fib(3)`** is calculated **2 times**.6
    
- **`fib(2)`** is calculated **3 times**.7
    
- **`fib(1)`** is calculated **5 times**.8
    

These repeated calculations are the "overlapping subproblems."9

---

### How Dynamic Programming Solves This

Dynamic programming uses two main techniques to avoid re-computing these subproblems:10

1. **Memoization (Top-Down):** This is a "top-down" approach that keeps the recursive structure.11 You create a lookup table (like an array or hash map) to store results.12 Before making a recursive call, you check if the result for that subproblem is already in the table.13
    
    - If **yes**, return the stored result.
        
    - If **no**, compute it recursively, **store it in the table**, and then return it.14
        
2. **Tabulation (Bottom-Up):** This is an "iterative" approach that builds the solution from the ground up.15 You start by solving the smallest subproblems first and store their results in a table. Then, you use these results to build up solutions to larger and larger subproblems until you reach the final answer.16
    
    - For `fib(5)`, you would calculate `fib(0)`, `fib(1)`, `fib(2)`, `fib(3)`, `fib(4)`, and finally `fib(5)` in order, storing each result as you go.
        

Both methods turn the inefficient exponential solution into a much faster linear-time solution.17

A problem must have **both** overlapping subproblems and **optimal substructure** (where an optimal solution to the main problem can be built from optimal solutions to its subproblems) to be solvable with dynamic programming.18

---
