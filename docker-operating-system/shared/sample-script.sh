#!/bin/bash
# Sample script demonstrating file sharing between containers

echo "Hello from the shared directory!"
echo "This file can be accessed from both Ubuntu and Alpine containers"
echo "Current date: $(date)"
echo "Running from: $(hostname)"

# Create a simple test file
echo "Test file created at $(date)" > /shared/test-output.txt

echo "Script completed successfully!"
