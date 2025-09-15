#!/bin/bash

# My Coding Practice Startup Script

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

# --- Main Execution --- 
echo "========================================="
echo "Running my algorithm practice script..."
echo "========================================="
echo

print_pyramid

echo "Script finished. Happy coding!"
