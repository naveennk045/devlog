**WHAT – Shortest Path Algorithm**

A **Shortest Path Algorithm** is used to find the **minimum distance or minimum cost path between two vertices in a graph** based on **edge weights**.

Depending on the problem, it can find:

- Shortest path from **one source to all vertices** (SSSP)
    
- Shortest path from **multiple sources** (MSSP)
    
- Shortest path between **all pairs of vertices** (APSP)
    

Graphs may be:

- **Directed or Undirected**
    
- **Weighted or Unweighted**
    
- With **positive or negative weights**
    

---

##  **WHY – Importance of Shortest Path Algorithms**

Shortest path algorithms are important because they are used in:

- **Navigation systems (GPS, Maps)**
    
- **Computer networks (routing of packets)**
    
- **Transportation and logistics**
    
- **Game development and robotics**
    
- **Social networks (minimum hops)**
    
- **Finance systems (arbitrage detection)**
    

They are a **core topic in graph theory** and are **frequently asked in university exams and placements**.

---

## **HOW – Core Concepts Used in Shortest Path**

###  **1. Basic Terminology**

- **Vertex (Node):** A point in the graph.
    
- **Edge:** A connection between two vertices.
    
- **Weight:** Cost associated with an edge.
    
- **Path:** A sequence of vertices connected by edges.
    
- **Distance:** Total cost of a path.
    
- **Source Vertex:** Starting vertex.
    
- **Destination Vertex:** Ending vertex.
    
- **Relaxation:** The process of updating the shortest distance.
    
- **Infinity (∞):** Initial value indicating unreachable distance.
    
- **Negative Weight:** Edge with weight less than zero.
    
- **Negative Cycle:** A cycle whose total weight is negative.
    

---

###  **2. Types of Shortest Path Problems**

1. **Single Source Shortest Path (SSSP)**  
    Finds shortest distance from one source to all vertices.
    
2. **Multi Source Shortest Path (MSSP)**  
    Finds shortest distance from multiple sources simultaneously.
    
3. **All Pairs Shortest Path (APSP)**  
    Finds shortest distance between every pair of vertices.
    

---

##  **MAJOR SHORTEST PATH ALGORITHMS (THEORY)**

---

###  **1. BFS (Shortest Path in Unweighted Graph)**

**Definition:**  
Breadth First Search is used to compute shortest paths in an **unweighted graph**.

**Key Characteristics:**

- Works when all edges have **equal weight**.
    
- Explores the graph **level by level**.
    
- The first time a vertex is visited gives its **shortest distance**.
    
- Uses a **queue data structure**.
    

**Time Complexity:** O(V + E)  
**Limitation:** Cannot be used for weighted graphs.

---

###  **2. Dijkstra’s Algorithm**

**Definition:**  
Dijkstra’s algorithm finds the shortest path from a **single source to all other vertices in a graph with non-negative edge weights**.

**Key Characteristics:**

- Based on the **Greedy strategy**.
    
- Always selects the vertex with the **minimum temporary distance**.
    
- Uses a **priority queue (min-heap)**.
    
- Repeatedly performs **relaxation**.
    

**Time Complexity:**

- O(E log V) using heap
    
- O(V²) using array
    

**Limitation:**

- **Does not work with negative edge weights**.
    
- Cannot detect negative cycles.
    

---

###  **3. Bellman–Ford Algorithm**

**Definition:**  
Bellman–Ford algorithm computes the shortest path from a single source in a graph **even when negative edge weights are present**.

**Key Characteristics:**

- Based on **Dynamic Programming**.
    
- Relaxes **all edges exactly (V – 1) times**.
    
- Can **detect negative weight cycles**.
    

**Negative Cycle Detection:**  
If any distance is updated in the **Vth iteration**, a negative cycle exists.

**Time Complexity:** O(VE)

**Use Case:**  
Used in **financial systems and routing protocols**.

---

###  **4. Shortest Path in Directed Acyclic Graph (DAG)**

**Definition:**  
In a **DAG**, shortest paths can be found using **topological sorting**.

**Key Characteristics:**

- Graph must be **directed and acyclic**.
    
- Works with **negative weights**.
    
- Vertices are processed in **topological order**.
    
- Edge relaxation is done once.
    

**Time Complexity:** O(V + E)

---

###  **5. Multi-Source Shortest Path (MSSP)**

**Definition:**  
Multi-source shortest path finds the **minimum distance of every node from the nearest source** when there are **multiple starting points**.

**Key Characteristics:**

- All source nodes are initialized with **distance = 0**.
    
- BFS is used for **unweighted graphs**.
    
- Dijkstra is used for **weighted graphs**.
    
- For negative weights, a **super-source** is added.
    

**Applications:**

- Nearest hospital
    
- Spread of fire or infection
    
- Rotten oranges problem
    

---

###  **6. All-Pairs Shortest Path – Floyd–Warshall Algorithm**

**Definition:**  
Floyd–Warshall algorithm finds the **shortest paths between all pairs of vertices**.

**Key Characteristics:**

- Uses **Dynamic Programming**.
    
- Works with **negative weights**.
    
- Uses a **distance matrix**.
    
- Repeatedly considers every vertex as an **intermediate node**.
    

**Time Complexity:** O(V³)  
**Space Complexity:** O(V²)

**Limitation:**

- Cannot handle **negative cycles**.
    

---

###  **7. 0–1 BFS (Special Case Algorithm)**

**Definition:**  
0–1 BFS is used when edge weights are **only 0 or 1**.

**Key Characteristics:**

- Uses a **double-ended queue (deque)**.
    
- Faster than Dijkstra for this special case.
    
- Maintains shortest distance efficiently.
    

**Time Complexity:** O(V + E)

---

## **RELAXATION (CORE CONCEPT)**

**Relaxation** is the process of checking whether a shorter path to a vertex can be found through another vertex.

It is the **foundation of all shortest path algorithms**.

Repeated relaxation ensures that:

- All possible shorter paths are considered.
    
- Final distances become optimal.
    

---

##  **NEGATIVE CYCLE**

A **negative cycle** is a cycle in which the **sum of all edge weights is negative**.

**Effect:**

- Shortest path becomes **undefined**.
    
- Distance value can decrease infinitely.
    

**Detection:**

- Only **Bellman–Ford algorithm** can detect negative cycles.
    

---

##  **GRAPH REPRESENTATION USED**

|Representation|Used In|
|---|---|
|Adjacency List|Dijkstra, DAG|
|Edge List|Bellman–Ford|
|Adjacency Matrix|Floyd–Warshall|
|Grid Graph|BFS, Dijkstra|

---

