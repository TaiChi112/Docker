# Shell Script Language: Beginner's Guide

## Introduction
Shell scripting is a way to automate tasks in Unix/Linux environments using a command-line interpreter (shell). It is similar to other programming languages in terms of variables, control flow, and functions, but is designed for system tasks and automation.

---

## Table of Contents
1. [What is a Shell?](#what-is-a-shell)
2. [Hello World Example](#hello-world-example)
3. [Variables](#variables)
4. [Input/Output](#inputoutput)
5. [Control Flow](#control-flow)
6. [Loops](#loops)
7. [Functions](#functions)
8. [Useful Commands](#useful-commands)
9. [Best Practices](#best-practices)
10. [References](#references)

---

## What is a Shell?
A shell is a command-line interface that allows users to interact with the operating system. Common shells include `bash`, `sh`, `zsh`, and `fish`.

## Hello World Example
```bash
#!/bin/bash
echo "Hello, World!"
```
Save as `main.sh`, then run:
```sh
chmod +x main.sh
./main.sh
```

## Variables
```bash
name="Alice"
echo "Hello, $name"
```
* No spaces around `=`
* Use `$` to access variable value

## Input/Output
```bash
read -p "Enter your name: " user
echo "Welcome, $user!"
```

## Control Flow
### If-Else
```bash
if [ "$name" = "Alice" ]; then
	echo "Hi Alice!"
else
	echo "You are not Alice."
fi
```

## Loops
### For Loop
```bash
for i in 1 2 3; do
	echo "Number: $i"
done
```
### While Loop
```bash
count=1
while [ $count -le 3 ]; do
	echo "Count: $count"
	count=$((count+1))
done
```

## Functions
```bash
greet() {
	echo "Hello, $1!"
}
greet "Bob"
```

## Useful Commands
- `ls` : List files
- `pwd` : Print working directory
- `cd` : Change directory
- `cat` : Show file content
- `grep` : Search text
- `chmod` : Change file permissions

## Best Practices
- Always start scripts with `#!/bin/bash` (shebang)
- Use comments (`#`) to explain code
- Quote variables: `"$var"`
- Test scripts with `bash -x script.sh` for debugging

## References
- [Shell Scripting Tutorial](https://www.shellscript.sh/)

---

## Data Structure & Algorithm Basics in Shell Script

### 1. Array (List)
```bash
# Declare array
arr=(3 1 4 1 5)
# Access element
echo "First element: ${arr[0]}"
# Print all elements
echo "All elements: ${arr[@]}"
# Length
echo "Length: ${#arr[@]}"
```

### 2. Linear Search
```bash
arr=(10 20 30 40 50)
target=30
found=0
for n in "${arr[@]}"; do
	if [ "$n" -eq "$target" ]; then
		found=1
		break
	fi
done
if [ $found -eq 1 ]; then
	echo "$target found!"
else
	echo "$target not found."
fi
```

### 3. Bubble Sort
```bash
arr=(5 2 9 1 5 6)
len=${#arr[@]}
for ((i=0; i<$len; i++)); do
	for ((j=0; j<$len-i-1; j++)); do
		if [ ${arr[j]} -gt ${arr[$((j+1))]} ]; then
			# swap
			temp=${arr[j]}
			arr[j]=${arr[$((j+1))]}
			arr[$((j+1))]=$temp
		fi
	done
done
echo "Sorted: ${arr[@]}"
```

### 4. String Reverse
```bash
str="hello"
rev=""
len=${#str}
for ((i=$len-1; i>=0; i--)); do
	rev="$rev${str:$i:1}"
done
echo "Reverse: $rev"
```

### 5. Factorial (Recursive)
```bash
factorial() {
	if [ $1 -le 1 ]; then
		echo 1
	else
		prev=$(factorial $(( $1 - 1 )))
		echo $(( $1 * prev ))
	fi
}
echo "Factorial 5: $(factorial 5)"
```
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Shell Scripting Tutorial](https://www.shellscript.sh/)
