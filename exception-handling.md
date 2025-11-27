
## JAVA Exception Handling

An **exception** is an event that occurs during program execution that disrupts the normal flow of instructions.

### Types of Exceptions

#### 1. Checked Exceptions
- **Checked at compile-time** - compiler forces you to handle them
- **Examples**: `IOException`, `SQLException`, `ClassNotFoundException`
- **Cause**: External factors like file not found, database connection issues
- **Handling**: Must be caught with try-catch or declared in method signature using `throws`

#### 2. Unchecked Exceptions
- **Checked at runtime** - compiler doesn't force handling
- **Examples**: `NullPointerException`, `ArrayIndexOutOfBoundsException`, `IllegalArgumentException`
- **Cause**: Programming errors, logical mistakes, invalid operations
- **Handling**: Optional to handle, but recommended for robust code

#### 3. Errors
- **Serious system-level problems** - typically cannot be recovered from
- **Examples**: `OutOfMemoryError`, `StackOverflowError`, `VirtualMachineError`
- **Cause**: System resource exhaustion, JVM failures
- **Handling**: Generally should NOT be caught or handled

### Key Corrections to Your Notes:

1. **Checked exceptions are NOT syntax errors** - syntax errors are compilation errors that prevent the program from compiling at all.

2. **Try-catch is used for both checked and unchecked exceptions**, but it's mandatory for checked exceptions.

3. **Errors vs Exceptions**: Errors are typically beyond the programmer's control, while exceptions can often be anticipated and handled.

### Example:
```java
// Checked Exception - must be handled
try {
    FileReader file = new FileReader("nonexistent.txt");
} catch (FileNotFoundException e) {
    System.out.println("File not found: " + e.getMessage());
}

// Unchecked Exception - optional to handle
try {
    int[] arr = new int[5];
    System.out.println(arr[10]); // ArrayIndexOutOfBoundsException
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("Invalid array index");
}
```




## PYTHON Exception Handling

Exception is an event that occurs during program execution that disrupts the normal flow of instructions.

### Python Exception Hierarchy
```
BaseException
 ├── SystemExit
 ├── KeyboardInterrupt
 ├── GeneratorExit
 └── Exception
      ├── StopIteration
      ├── ArithmeticError
      │    ├── ZeroDivisionError
      │    └── FloatingPointError
      ├── AssertionError
      ├── AttributeError
      ├── EOFError
      ├── ImportError
      ├── LookupError
      │    ├── IndexError
      │    └── KeyError
      ├── NameError
      ├── OSError
      │    ├── FileNotFoundError
      │    └── PermissionError
      ├── TypeError
      ├── ValueError
      └── RuntimeError
```

### Key Differences from Java:

1. **No Checked/Unchecked Distinction**: Python doesn't have checked exceptions like Java. All exceptions are unchecked.

2. **Syntax**: Python uses `try-except-else-finally` instead of `try-catch`

3. **Exception Types**: Different naming convention (PascalCase)

### Basic Syntax:
```python
try:
    # Code that might raise an exception
    result = 10 / 0
except ZeroDivisionError:
    # Handle specific exception
    print("Cannot divide by zero!")
except (TypeError, ValueError) as e:
    # Handle multiple exceptions
    print(f"Error: {e}")
else:
    # Executes if no exception occurred
    print("Division successful")
finally:
    # Always executes
    print("This always runs")
```

### Common Python Exceptions:
- `ZeroDivisionError`: Division by zero
- `IndexError`: List index out of range
- `KeyError`: Dictionary key not found
- `FileNotFoundError`: File doesn't exist
- `TypeError`: Wrong data type
- `ValueError`: Invalid value
- `NameError`: Variable not defined

### Example:
```python
try:
    numbers = [1, 2, 3]
    print(numbers[5])  # IndexError
except IndexError:
    print("Index out of range!")
```




