#!/bin/bash

# My Coding Practice Startup Script
# Author: A curious student
# I run this to see a collection of algorithms I'm learning!

# --- Algorithm 1: Pyramid Pattern --- 
print_pyramid() {
    echo "--- Pyramid Pattern ---"
    rows=5
    for ((i=1; i<=rows; i++)); do
        for ((j=1; j<=rows-i; j++)); do
            echo -n "  "
        done
        for ((j=1; j<=2*i-1; j++)); do
            echo -n "* "
        done
        echo
    done
    echo
}

# --- Algorithm 2: Breadth-First Search (BFS) --- 
# Just a conceptual representation for now.
bfs_example() {
    echo "--- BFS Traversal Example ---"
    echo "Graph: A -> B, A -> C, B -> D, B -> E, C -> F"
    echo "BFS starting from A: A, B, C, D, E, F"
    echo "(This is a placeholder, need to implement with a real graph structure!)"
    echo
}

# --- Algorithm 3: Depth-First Search (DFS) ---
# Conceptual representation.
dfs_example() {
    echo "--- DFS Traversal Example ---"
    echo "Graph: A -> B, A -> C, B -> D, B -> E, C -> F"
    echo "DFS starting from A: A, B, D, E, C, F"
    echo "(Placeholder for now, will implement properly later.)"
    echo
}

# --- Algorithm 4: Sliding Window --- 
# Finds the max sum of a subarray of size k
sliding_window_example() {
    echo "--- Sliding Window: Max Sum Subarray ---"
    arr=(1 4 2 10 2 3 1 0 20)
    k=4
    n=${#arr[@]}
    
    if [ $n -lt $k ]; then
        echo "Invalid operation: array size is smaller than window size."
        return
    fi

    max_sum=0
    for ((i=0; i<k; i++)); do
        max_sum=$((max_sum + arr[i]))
    done

    window_sum=$max_sum
    for ((i=k; i<n; i++)); do
        window_sum=$((window_sum + arr[i] - arr[i-k]))
        if [ $window_sum -gt $max_sum ]; then
            max_sum=$window_sum
        fi
    done

    echo "Array: ${arr[@]}"
    echo "Window size (k): $k"
    echo "Max sum of a subarray of size $k is: $max_sum"
    echo
}

# --- Main Execution --- 
echo "========================================="
echo "Running my algorithm practice script..."
echo "========================================="
echo

print_pyramid
bfs_example
dfs_example
sliding_window_example

echo "Script finished. Happy coding!"
