#!/bin/bash
set -euo pipefail

# My Coding Practice Startup Script
# Author: A curious student
# I run this to see a collection of algorithms I'm learning!

# --- Algorithm 1: Pyramid Pattern ---
print_pyramid() {
    echo "--- Pyramid Pattern ---"
    local rows="${1:-5}"
    if (( rows <= 0 )); then
        echo "Invalid operation: rows must be positive."
        return 1
    fi
    local i j
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
bfs_example() {
    echo "--- BFS Traversal Example ---"
    echo "Graph: A -> B, A -> C, B -> D, B -> E, C -> F"
    local -A graph=(
        [A]="B C"
        [B]="D E"
        [C]="F"
        [D]=""
        [E]=""
        [F]=""
    )
    local -A visited=()
    local -a queue=("A")
    local -a order=()
    visited[A]=1

    while (( ${#queue[@]} > 0 )); do
        local current="${queue[0]}"
        queue=("${queue[@]:1}")
        order+=("$current")

        local neighbor
        for neighbor in ${graph[$current]:-}; do
            if [[ -z "${visited[$neighbor]:-}" ]]; then
                visited[$neighbor]=1
                queue+=("$neighbor")
            fi
        done
    done

    local result=""
    local node
    for node in "${order[@]}"; do
        if [[ -z "$result" ]]; then
            result="$node"
        else
            result="$result, $node"
        fi
    done
    echo "BFS starting from A: $result"
    echo
}

# --- Algorithm 3: Depth-First Search (DFS) ---
dfs_example() {
    echo "--- DFS Traversal Example ---"
    echo "Graph: A -> B, A -> C, B -> D, B -> E, C -> F"
    local -A graph=(
        [A]="B C"
        [B]="D E"
        [C]="F"
        [D]=""
        [E]=""
        [F]=""
    )
    local -A visited=()
    local -a stack=("A")
    local -a order=()

    while (( ${#stack[@]} > 0 )); do
        local last_idx=$(( ${#stack[@]} - 1 ))
        local current="${stack[$last_idx]}"
        unset "stack[$last_idx]"
        stack=("${stack[@]}")

        if [[ -n "${visited[$current]:-}" ]]; then
            continue
        fi
        visited[$current]=1
        order+=("$current")

        local -a neighbors=()
        read -r -a neighbors <<< "${graph[$current]:-}"
        local idx
        for (( idx=${#neighbors[@]}-1; idx>=0; idx-- )); do
            local neighbor="${neighbors[$idx]}"
            if [[ -z "${visited[$neighbor]:-}" ]]; then
                stack+=("$neighbor")
            fi
        done
    done

    local result=""
    local node
    for node in "${order[@]}"; do
        if [[ -z "$result" ]]; then
            result="$node"
        else
            result="$result, $node"
        fi
    done
    echo "DFS starting from A: $result"
    echo
}

# --- Algorithm 4: Sliding Window ---
# Finds the max sum of a subarray of size k
sliding_window_example() {
    echo "--- Sliding Window: Max Sum Subarray ---"
    local -a arr=(1 4 2 10 2 3 1 0 20)
    local k="${1:-4}"
    local n=${#arr[@]}

    if (( k <= 0 || n < k )); then
        echo "Invalid operation: window size must be between 1 and array size."
        return 1
    fi

    local window_sum=0
    local i
    for ((i=0; i<k; i++)); do
        window_sum=$((window_sum + arr[i]))
    done

    local max_sum=$window_sum
    for ((i=k; i<n; i++)); do
        window_sum=$((window_sum + arr[i] - arr[i-k]))
        if (( window_sum > max_sum )); then
            max_sum=$window_sum
        fi
    done

    echo "Array: ${arr[*]}"
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

