### Problem Statement

You are playing a digital version of Carrom on an `N x N` square board. The board has coins placed on some of the grid cells, and your striker can shoot in one of four directions: up, down, left, or right from its current position.

Each coin has a value `v`, and once hit by the striker, the coin slides in the same direction until it either:

- hits another coin (and both coins are removed), or
    
- hits the edge of the board (in which case the coin is removed).
    

However, if two coins collide, their values are added to your score.

The striker starts at a given position `(Sx, Sy)`. You are allowed at most one shot in any one direction (U, D, L, R).

Your task is to determine the maximum possible score you can achieve with a single shot in any of the four directions.

### Input Format

First line contains a single integer N representing the size of the square board (N x N).

Second line contains two integers sx and sy representing the starting position of the striker.

Third line contains a single integer M representing the number of coins on the board.

Next M lines each contain three integers x, y, and v representing the position (x, y) of a coin and its value v.

### Output Format

Print the the maximum possible score you can achieve with a single shot in any of the four directions.

### Constraints

1 ≤ N ≤ 100

0 ≤ Sx,Sy < N

0 ≤ M ≤ N^2

0 ≤ xi, yi < N

1 ≤ vi ≤ 10^4

### Sample Testcase 1

#### Testcase Input

4 1 1 3 1 2 4 1 3 6 1 0 5

#### Testcase Output

10

##### Explanation

Striker at (1,1)

Right:  
Hits (1,2)=4, slides to (1,3)=6 → Score = 4+6 = 10

Left:  
Hits (1,0)=5, slides to edge → Score = 5

Up / Down → No coins  
Output: 10

### Sample Testcase 2

#### Testcase Input

5 2 2 4 2 3 5 2 4 10 0 2 7 1 2 3

#### Testcase Output

15

##### Explanation

Striker starts at (2,2

Coins at:  
Right → (2,3)=5, then (2,4)=10 → collide → Score = 5+10 = 15  
Up → (1,2)=3, then (0,2)=7 → collide → Score = 3+7 = 10  
Left and Down → No coins ahead

Output: 15

--------------------------

### Problem Statement

You are given a directed time-layered graph with N nodes (numbered `1` to `n`) and M directed edges. Each edge represents a time jump between nodes and has an associated base energy cost.

Edges can be of two types:

- `'S'` (Stable): The energy cost to traverse this edge is always equal to `baseCost`.
    
- `'U'` (Unstable): The energy cost to traverse this edge depends on your current time (i.e., how many jumps you've already made). The cost is calculated as:  
    cost = baseCost + k × (current_time % 10)
    
    Where `k` is a hidden distortion constant unique to each unstable edge. You cannot see `k` directly, but you can call a function:  
    `int queryK(int edgeId)   `
    
    - - `edgeId` is 0-indexed (from `0` to `m-1`).
            
        - It returns the value of `k` for that specific edge.
            
        - You can call this function at most once per edge. Further calls on the same `edgeId` will return `-1`.
            
    
    You start at a given node `start` at time 0, and at every jump, the time increases by 1. Each jump takes 1 unit of time.
    
    Your goal is to reach a target node `target` using a path such that the total energy used is less than or equal to `maxEnergy`. Among all such paths, find the one that reaches the target in the minimum possible time.
    
    If no such path exists, output `-1`.
    

### Input Format

n m  
start target maxEnergy  
u1 v1 cost1 type1  
...  
um vm costm typem  
  

`n`: number of nodes

`m`: number of edges

`start`, `target`: source and destination nodes

`maxEnergy`: maximum energy allowed

Each edge:

`u v`: from node `u` to node `v`

`cost`: base energy cost

`type`: `"S"` for Stable, `"U"` for Unstable

### Output Format

Minimum time to reach target within maxEnergy, else -1

### Constraints

`2 ≤ N ≤ 10^4`

`1 ≤ M ≤ 10^4`

`1 ≤ u, v ≤ n`

`1 ≤ baseCost ≤ 10^3`

All costs are integers.

`queryK(edge_id)` returns `1 ≤ k ≤ 100`

You can use `queryK()` only once per unstable edge, otherwise it returns -1.

### Sample Testcase 1

#### Testcase Input

3 3 1 3 5 1 2 3 U 2 3 4 U 1 3 10 S

#### Testcase Output

-1

##### Explanation

Try 1 → 2 → 3:

Energy = (3 + 1) + (4 + 2) = 10 > 5  not valid

Try 1 → 3 directly:

Energy = 10 not valid

None of the paths are within the allowed energy of 5.

### Sample Testcase 2

#### Testcase Input

5 6 1 5 20 1 2 4 S 2 5 12 U 1 3 5 U 3 4 2 S 4 5 2 U 2 4 2 S

#### Testcase Output

2

##### Explanation

Two possible paths:

Path A: 1 → 2 → 5

Energy = 4 + (12 + 1) = 17 valid

Time = 2 

Path B: 1 → 3 → 4 → 5

Energy = (5 + 1) + 2 + (2 + 3) = 13  valid

Time = 3 

Path A is faster, both are valid.  
Choose the one with minimum time.