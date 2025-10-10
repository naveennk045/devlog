
# DSA Master Handbook

---

## Global Time Complexity Cheatsheet

|**Complexity**|**Big‑O**|**Typical Examples**|
|---|---|---|
|Constant|O(1)|Hash lookup, stack push/pop, queue enqueue/dequeue|
|Logarithmic|O(log n)|Binary search, balanced BST ops, heap ops|
|Linear|O(n)|Array/linked list scan, counting sort (range‑bounded)|
|Linearithmic|O(n log n)|Merge/heap sort, D&C on balanced splits|
|Quadratic|O(n²)|Naive string matching, bubble/insertion sort|
|Cubic|O(n³)|Floyd‑Warshall, DP on triples|
|Exponential|O(2^n)|Subset/partition brute force, naive TSP|
|Factorial|O(n!)|Permutations brute force|

Notes: Amortized means averaged over a sequence (e.g., dynamic array push). For sparse graphs V ~ nodes, E ~ edges; traversals run in O(V+E).

---

# Part I — Data Structures

## 1) Array (Static & Dynamic)

**What:** Contiguous block of memory; random access by index.

**Why:** Fast indexed reads; cache‑friendly; foundation for many structures (heaps, hash tables buckets, adjacency lists).

**How:** Static fixed length; dynamic uses _resize–copy_ (typically ×2 growth) to keep amortized O(1) push_back.

**Operations & Time:**

- Access: O(1)
- Search (unsorted): O(n)
- Insert/Delete at end (dynamic): amortized O(1); at middle: O(n)

**Advantages:** Simple; minimal overhead; best constant factors; vectorized.

**Disadvantages:** Middle insert/delete costly; resizing copies; static arrays fixed size.

**Considerations:** Choose capacity growth factor (usually 2); check bounds; prefer arrays for dense data.

**Use cases:** Heaps; circular buffers; DP tables; adjacency lists.

---

## 2) Linked List (Singly/Doubly/Circular/Skip)

**What:** Nodes linked via pointers; not contiguous.

**Why:** O(1) insert/delete with node reference; stable iterators under insert.

**How:** Maintain head/tail; doubly add prev pointer; skip list adds level towers for O(log n) search.

**Operations & Time:**

- Access/Search: O(n)
- Insert/Delete at known node: O(1)
- Skip list search/insert/delete: O(log n) expected

**Advantages:** Cheap splicing; no resize copies.

**Disadvantages:** Poor cache locality; extra memory; slow random access.

**Considerations:** Sentinel nodes to simplify edge cases; memory fragmentation.

**Use cases:** Queues, LRU caches (with hash map), ordered maps (skip list variants), music playlists.

---

## 3) Stack (incl. Monotonic/Min‑Max Stack)

**What:** LIFO container; top is only access point.

**Why:** Natural for nested states, recursion simulation, expression parsing.

**How:** Array or linked list; for monotonic, maintain increasing/decreasing invariant.

**Operations & Time:** push/pop/peek: O(1)

**Variants:**

- **Monotonic stack:** Next greater/smaller element, histogram largest rectangle, daily temperatures — O(n).
- **Min/Max stack:** Track current min/max with auxiliary stack — O(1) per op.

**Use cases:** DFS (iterative), undo, syntax checking, span problems.

---

## 4) Queue / Deque (incl. Monotonic Queue)

**What:** FIFO; Deque supports both ends.

**Why:** Scheduling, breadth traversal, sliding windows.

**How:** Circular buffer or linked list; monotonic deque maintains order while keeping candidates.

**Operations & Time:** enqueue/dequeue/peek: O(1); deque push/pop both ends: O(1)

**Variants:** Monotonic deque for sliding window max/min — O(n) per pass.

**Use cases:** BFS; producer–consumer; rate limiting; sliding window problems.

---

## 5) Hash Table (Hash Map/Set)

**What:** Key→bucket via hash; resolve collisions by chaining or open addressing.

**Why:** Average O(1) lookups/updates; ubiquitous for indexing.

**How:** Good hash function; maintain load factor via resize.

**Operations & Time:** insert/find/erase: Avg O(1), Worst O(n) (rare with good design).

**Advantages:** Fast; simple API; flexible keys.

**Disadvantages:** Non‑ordered; worst cases; costly iteration ordering; poor for prefix/range queries.

**Considerations:** Load factor (e.g., 0.75); hash quality; DoS via collisions; custom equals.

**Use cases:** Caches, symbol tables, frequency maps, deduplication.

---

## 6) Heap / Priority Queue (Binary/Fibonacci/Binomial)

**What:** Partially ordered complete tree where parent ≦/≧ children.

**Why:** Efficient top‑k, event simulation, shortest paths (Dijkstra), schedulers.

**How:** Array representation; sift‑up/down for insert/extract.

**Operations & Time:** peek: O(1); insert: O(log n); extract‑min/max: O(log n); build‑heap: O(n).

**Variants:**

- **Binary heap (std priority_queue):** Best constants.
- **Binomial/Fibonacci heap:** Better amortized decrease‑key; theoretical; used in specialized settings.

**Use cases:** Dijkstra/Prim; k‑way merge; median maintenance (two heaps).

---

## 7) Trees (BST family, Red‑Black, AVL, Treap, Splay, Order‑Statistic)

**What:** Hierarchical; BST keeps in‑order key ordering.

**Why:** Ordered set/map with logarithmic operations; range queries; order statistics.

**Base form for ordered maps/sets:** **Red‑Black Tree** (e.g., TreeSet/TreeMap).

**Operations & Time (balanced BST):** search/insert/delete: O(log n); inorder successor/predecessor: O(log n).

**Variants:**

- **AVL:** Stricter balance → faster lookups; more rotations on updates.
- **Red‑Black:** Fewer rotations; common stdlib base.
- **Treap:** BST + heap priorities; randomized balance.
- **Splay:** Recent items fast (amortized O(log n)); no strict worst‑case.
- **Order‑Statistic Tree:** Augments subtree sizes for k‑th/smaller‑than queries in O(log n).

**Use cases:** Sorted containers, leaderboards, interval and range queries (with augmentation).

---

## 8) Tries (Prefix Trees) & String Indexes

**What:** N‑ary tree keyed by characters.

**Why:** Prefix queries and dictionary ops in O(L) where L is string length.

**Operations & Time:** insert/search/delete: O(L); enumerate by prefix: O(k) for k results.

**Variants:**

- **Compressed/Patricia trie** (radix tree) to save space.
- **Ternary Search Tree (TST):** Space‑efficient, BST‑like branching.
- **Aho‑Corasick automaton:** Multi‑pattern search in O(n + matches).
- **Suffix Array/Tree:** Fast substring queries; suffix array with LCP enables O(1)/O(log n) RMQ‑based queries.

**Use cases:** Autocomplete, spellcheckers, plagiarism detection, DNA indexing.

---

## 9) Disjoint Set Union (Union‑Find)

**What:** Maintains partition of elements into disjoint sets.

**Why:** Near‑constant merges/finds; backbone for Kruskal’s MST, connectivity queries.

**How:** Parent array + path compression + union by rank/size.

**Time:** Amortized α(n) per op (inverse Ackermann, effectively constant).

**Use cases:** Dynamic connectivity, cycle detection in undirected graphs, clustering.

---

## 10) Segment Tree (with Lazy Propagation) & Fenwick Tree (BIT)

**What:** Range query/update structures over arrays.

**Why:** Support subarray queries with updates faster than O(n).

**How:**

- **Segment Tree:** Complete binary tree over segments; push lazy tags for range updates.
- **Fenwick Tree (BIT):** Binary indexed partial sums via lowbit trick.

**Time:**

- Segment tree: query/update O(log n); build O(n).
- Lazy range update + range query: O(log n).
- BIT: point update + prefix sum O(log n); range via prefix differences.

**Use cases:** Range sums/min/max, inversion counts, 2D variants, offline queries.

---

## 11) Graph Representations

**Adjacency List:** Space O(V+E), traversal O(V+E). Best for sparse graphs.

**Adjacency Matrix:** Space O(V²), O(1) edge checks; good for dense graphs and DP like Floyd‑Warshall.

**Edge List:** Minimal storage for algorithms like Kruskal (sort edges by weight).

---

## 12) Additional Structures

- **Bloom Filter:** Probabilistic set with false positives (no false negatives). Insert/query O(k) where k = hash count.
- **LRU/LFU Cache:** Usually hash map + doubly linked list / heap.
- **Deque‑based Sliding Window:** Monotonic maintenance for O(1) amortized per step.
- **K‑D Tree / Quad‑Tree / R‑Tree:** Spatial indexing; nearest neighbor; range search.
- **Persistent DS (e.g., persistent segment tree):** Keep past versions; functional updates in O(log n).

---

# Part II — Algorithms by Topic 

## A) Arrays & Searching/Sorting

### Sorting

- **Comparison sorts:**
- **Merge Sort:** Stable; O(n log n) time, O(n) extra; divide & conquer.
- **Quick Sort:** In‑place; avg O(n log n), worst O(n²); randomized pivot mitigates worst case.
- **Heap Sort:** O(n log n), in‑place, not stable; uses heap.
- **Non‑comparison (range‑bounded):** Counting Sort O(n + k), Radix Sort O((n + k)·d), Bucket Sort (avg lin.)

**Use cases:** Large datasets (merge), memory‑tight (quick/heap), integers with small ranges (counting/radix).

### Searching

- **Binary Search:** O(log n) on sorted arrays. Patterns: lower_bound/upper_bound, first/last true, search on answer (parametric search).
- **Ternary Search:** Unimodal function optimization.

### Sliding Window & Two Pointers

- Fixed/variable window; typical O(n). Monotonic deque for max/min.

### Prefix/Suffix & Difference Arrays

- Range sums; subarray min/max; IMOS technique for range add.

### Kadane & Variants

- Max subarray O(n); 2D extension O(n³) with prefix sums.

---

## B) Strings

- **KMP:** Linear O(n+m); prefix function (π) for pattern jumps.
- **Z‑Algorithm:** Z‑array for matches; O(n+m).
- **Rabin–Karp:** Rolling hash; avg O(n+m), worst O(nm); good for multiple patterns with mod hashing.
- **Manacher:** Longest palindromic substring in O(n).
- **Trie/TST/Aho‑Corasick:** See DS section; AC does multi‑pattern in O(n + matches).
- **Suffix Array + LCP (Kasai) & RMQ:** Substring queries, lexicographic suffix order; build O(n log n) or O(n).
- **Suffix Automaton (SAM):** All substrings of a string; many queries in O(length).

Use cases: Search, plagiarism, DNA, autocomplete, compression.

---

## C) Mathematics & Number Theory

- **Prime Sieve (Eratosthenes/Segmented):** O(n log log n); memory O(n).
- **GCD/LCM (Euclid):** O(log min(a,b)).
- **Modular Arithmetic:** Fast pow O(log p); inverses via Fermat or Extended Euclid.
- **Combinatorics:** nCr precompute with factorials & mod inverse; Pascal DP.
- **Prefix XOR / Bit Tricks:** Parity, subset tricks.
- **Matrix Exponentiation:** Solve linear recurrences in O(k³ log n).

---

## D) Graphs

- **Traversals:** BFS/DFS O(V+E). Multi‑source BFS by pushing all sources initially.
- **Shortest Paths:**
- **Dijkstra (non‑neg edges):** O((V+E) log V) with heap.
- **Bellman‑Ford:** O(V·E); detects negative cycles.
- **SPFA:** Heuristic improvement; worst O(V·E).
- **Floyd‑Warshall:** All‑pairs O(V³).
- **MST:** Kruskal (sort edges + DSU) O(E log E); Prim (heap) O(E log V).
- **Topological Sort:** Kahn (indegree queue) or DFS ordering; DAGs only.
- **SCC:** Kosaraju (2 DFS) or Tarjan (lowlink) O(V+E).
- **Bridges/Articulation Points:** Tarjan via DFS times O(V+E).
- **Eulerian Path/Circuit:** Degree conditions + Hierholzer O(V+E).

### **Matching**

**Bipartite Matching (Unweighted)**

- **Hopcroft–Karp:** O(√V · E) using layered BFS + DFS augmenting paths.
- **Hungarian Algorithm (a.k.a. Kuhn–Munkres):** O(V³) for maximum weight matching.

**General Graph Matching**

- **Edmonds’ Blossom Algorithm:** O(V³), finds maximum matching in general graphs.

**Use Cases:**

- Job assignment, stable pairing, scheduling with constraints, network resource allocation.

---

### **Flows & Cuts**

**Max Flow**

- **Ford–Fulkerson:** O(E · max_flow) worst-case; simple but slow for large capacities.
- **Edmonds–Karp:** O(V · E²) using BFS for shortest augmenting paths.
- **Dinic’s Algorithm:** O(E · √V) for unit networks; O(E · V²) general.

**Min-Cut / Max-Flow Theorem:** Max flow value equals min cut capacity (important in connectivity problems).

**Use Cases:**

- Network routing, bipartite matching, circulation with demands, image segmentation.

---

### **Special Graph Topics**

- **Lowest Common Ancestor (LCA):**
    - Binary Lifting: O(log N) queries, O(N log N) preprocess.
    - Euler Tour + RMQ: O(1) queries, O(N log N) preprocess.
- **Tree Centroid Decomposition:** Break tree for divide & conquer in O(N log N).
- **Heavy-Light Decomposition:** Path queries/updates on trees in O(log² N).
- **2-SAT:** Implication graph + SCC in O(V+E).

# Part II — Patterns & Techniques by Topic 
## **D) Recursion & Backtracking**

### **1. Recursion**

- **Definition:** A function calls itself to solve a smaller version of the problem.
- **Why:** Mirrors divide & conquer logic, useful for tree/graph traversals and problems with natural recursive structure.
- **Structure:**
    - **Base Case:** Stops recursion.
    - **Recursive Case:** Break problems into smaller subproblems.
- **Complexity:** Often exponential without memoization; varies per problem.
- **Use Cases:**
    - Binary search
    - Merge sort / Quick sort
    - Tree traversals (DFS, inorder, preorder, postorder)
    - Divide & conquer matrix multiplication
- **Considerations:** Stack overflow risk; tail recursion optimization (if language supports).

---

### **2. Backtracking**

- **Definition:** DFS-based search that builds candidates incrementally and abandons ("backtracks") when constraints fail.
- **Why:** Systematically explores solution space with pruning.
- **Structure:**
    - **Choose:** Make a choice.
    - **Explore:** Recursively continue.
    - **Unchoose:** Revert choice before trying the next option.
- **Complexity:** Usually exponential in worst case (O(kⁿ) for many combinatorics problems).
- **Patterns:**
    - **Subsets / Combinations:** Explore with inclusion/exclusion.
    - **Permutations:** Swap elements or track used flags.
    - **Constraint Satisfaction:** Sudoku, N-Queens, word search.
    - **Hamiltonian paths / Knight’s tour** in graphs.
- **Optimization:** Use heuristics like “most constrained first” (reduce branching factor).

---

### **3. Relationship Between Recursion & Backtracking**

- Backtracking is a **specialized use** of recursion.
- Recursion is about **breaking down problems**; backtracking is about **exploring and pruning search space**.

---


## **E) Dynamic Programming (DP)**

### **1. What & Why**

- **Definition:** Solve problems by breaking them into overlapping subproblems and storing results to avoid recomputation.
- **Why:** Converts exponential recursion to polynomial time.
- **Core Properties:**
    - **Optimal Substructure**
    - **Overlapping Subproblems**

---

### **2. Approaches**

- **Top-down (Memoization):** Recursion + cache.
- **Bottom-up (Tabulation):** Iterative fill.
- **State Compression:** Bitmask or rolling arrays to reduce space.

---

### **3. Common Patterns**

- **1D DP:** Fibonacci, coin change, LIS (O(n log n) with patience sort), maximum sum subsequence.
- **2D DP:** Edit distance, matrix paths, grid DP.
- **Knapsack Family:** 0/1 knapsack, bounded, unbounded.
- **Interval DP:** Matrix chain multiplication, palindrome partitioning.
- **Tree DP:** DP on subtrees, rerooting techniques.
- **Digit DP:** Counting numbers satisfying digit constraints.

---

### **4. Optimizations**

- **Monotonic Queue Optimization:** For range DP transitions.
- **Convex Hull Trick:** Optimize DP with linear transitions.
- **Divide & Conquer Optimization:** If quadrangle inequality holds.
- **Knuth Optimization:** Specialized for certain partition problems.

---

## **F) Greedy Algorithms**

### **1. Definition & Idea**

- Build a solution step-by-step by choosing the **locally optimal** option, hoping for global optimality.

### **2. Common Applications**

- **Interval Scheduling:** Earliest finish time first.
- **Activity Selection:** Similar to interval scheduling.
- **Huffman Coding:** Build optimal prefix code.
- **Graph:** Kruskal’s and Prim’s for MST.
- **Greedy Coin Change:** Works if the coin system is canonical.

---

## **G) Graph Algorithms**

### **1. Traversal**

- BFS: O(V+E)
- DFS: O(V+E)
- Multi-source BFS: Initialize queue with multiple starting nodes.

### **2. Shortest Paths**

- Dijkstra (O((V+E) log V), non-negative weights)
- Bellman-Ford (O(V·E), handles negative weights)
- Floyd–Warshall (O(V³), all pairs)

---

### **3. MST (Minimum Spanning Tree)**

- **Kruskal’s:** Sort edges + DSU. O(E log E)
- **Prim’s:** Priority queue. O(E log V)

---

### **4. Other Key Graph Concepts**

- **Topological Sort** (Kahn’s, DFS) — DAGs only.
- **SCC (Strongly Connected Components)** — Tarjan’s or Kosaraju’s.
- **Bridges & Articulation Points** — Tarjan’s DFS lowlink method.
- **Flow algorithms:** Ford–Fulkerson, Edmonds–Karp, Dinic’s.

---

## **H) Common Problem-Solving Patterns**

- **Sliding Window**
- **Two Pointers**
- **Prefix/Suffix Computations**
- **Binary Search on Answer**
- **Bitmask Enumeration**
- **Meet in the Middle**
- **Sweep Line**
- **Union-Find Connectivity**
- **Heap-based Incremental Updates**
