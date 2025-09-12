# Kotlin Learning Syllabus

Welcome to Kotlin! Given your programming background, this syllabus is designed to be efficient while covering all essential concepts. I'll structure it in a progressive way with practical examples.

## Phase 1: Kotlin Fundamentals (Week 1-2)

### 1. Setting Up Environment & Basic Syntax
- Install IntelliJ IDEA (best Kotlin support)
- Create your first Kotlin project (JVM, script, or multiplatform)
- Hello World program and basic structure

```kotlin
// Your first Kotlin program
fun main() {
    println("Hello, World!")
    val name = "Kotlin Learner"
    println("Hello, $name!")
}
```

### 2. Variables and Data Types
- `val` vs `var` (immutable vs mutable)
- Type inference and explicit typing
- Basic types: Int, String, Boolean, Double, etc.
- String templates and multiline strings

```kotlin
fun variablesDemo() {
    val immutable = "I can't be changed"  // Read-only (recommended)
    var mutable = "I can be changed"     // Mutable
    
    // Type inference
    val name = "Alice"           // Inferred as String
    val age = 25                 // Inferred as Int
    val height: Double = 5.9     // Explicit type
    
    // String templates
    println("$name is $age years old and ${height}ft tall")
    
    // Multiline string
    val message = """
        This is a multiline
        string in Kotlin
    """.trimIndent()
}
```

### 3. Control Flow
- If-else expressions (not just statements)
- When expressions (powerful switch replacement)
- For, while, and do-while loops
- Ranges and progression

```kotlin
fun controlFlowDemo() {
    // If as expression
    val max = if (a > b) a else b
    
    // When expression (like enhanced switch)
    val grade = when (score) {
        in 90..100 -> "A"
        in 80..89 -> "B"
        in 70..79 -> "C"
        else -> "F"
    }
    
    // For loop with ranges
    for (i in 1..5) print(i) // 12345
    for (i in 1 until 5) print(i) // 1234
    for (i in 5 downTo 1) print(i) // 54321
    for (i in 1..10 step 2) print(i) // 13579
}
```

## Phase 2: Core Concepts (Week 3-4)

### 4. Functions
- Function declaration and usage
- Default arguments and named parameters
- Single-expression functions
- Extension functions

```kotlin
// Regular function
fun greet(name: String, message: String = "Hello"): String {
    return "$message, $name!"
}

// Single-expression function
fun square(x: Int) = x * x

// Function with named parameters
fun createUser(name: String, age: Int, isAdmin: Boolean = false) {
    // ...
}

// Usage
createUser(name = "Alice", age = 25, isAdmin = true)

// Extension function
fun String.addEnthusiasm(amount: Int = 1) = this + "!".repeat(amount)

fun main() {
    println("Hello".addEnthusiasm(3)) // Hello!!!
}
```

### 5. Null Safety
- Nullable types (`?` operator)
- Safe calls (`?.`)
- Elvis operator (`?:`)
- Non-null assertion (`!!`)
- Safe casts (`as?`)

```kotlin
fun nullSafetyDemo() {
    var nullableString: String? = "This can be null"
    nullableString = null // This is OK
    
    val length = nullableString?.length // Safe call - returns null if nullableString is null
    
    val lengthOrDefault = nullableString?.length ?: 0 // Elvis operator
    
    // This will throw NPE if nullableString is null - avoid when possible
    val forcedLength = nullableString!!.length 
}
```

### 6. Collections
- Lists, sets, and maps
- Read-only vs mutable collections
- Functional operations on collections (filter, map, reduce, etc.)

```kotlin
fun collectionsDemo() {
    // Read-only list
    val readOnlyList = listOf("a", "b", "c")
    
    // Mutable list
    val mutableList = mutableListOf(1, 2, 3)
    mutableList.add(4)
    
    // Functional operations
    val numbers = listOf(1, 2, 3, 4, 5, 6)
    val evenSquares = numbers
        .filter { it % 2 == 0 }
        .map { it * it }
    
    println(evenSquares) // [4, 16, 36]
    
    // Maps
    val map = mapOf(1 to "one", 2 to "two", 3 to "three")
    println(map[2]) // "two"
}
```

## Phase 3: Object-Oriented Programming (Week 5)

### 7. Classes and Objects
- Class declaration and properties
- Constructors (primary and secondary)
- Inheritance and overriding
- Data classes
- Enum classes

```kotlin
// Regular class with primary constructor
class Person(val name: String, var age: Int) {
    // Property with custom getter
    val isAdult: Boolean
        get() = age >= 18
}

// Data class (automatically implements equals, hashCode, toString, copy)
data class User(val id: Int, val name: String, val email: String)

// Inheritance
open class Animal(val name: String) {
    open fun makeSound() {
        println("Some generic animal sound")
    }
}

class Dog(name: String) : Animal(name) {
    override fun makeSound() {
        println("Woof!")
    }
}

// Enum class
enum class Direction {
    NORTH, SOUTH, EAST, WEST
}

fun enumDemo() {
    val direction = Direction.NORTH
    when (direction) {
        Direction.NORTH -> println("Going north")
        Direction.SOUTH -> println("Going south")
        // ...
    }
}
```

### 8. Objects and Companions
- Object expressions (anonymous classes)
- Object declarations (singletons)
- Companion objects

```kotlin
// Singleton
object DatabaseManager {
    fun connect() {
        // ...
    }
}

// Usage
DatabaseManager.connect()

// Companion object (like static members but more powerful)
class MyClass {
    companion object {
        fun create(): MyClass = MyClass()
        const val CONSTANT = "constant"
    }
}

// Usage
val instance = MyClass.create()
println(MyClass.CONSTANT)
```

## Phase 4: Advanced Features (Week 6)

### 9. Lambdas and Higher-Order Functions
- Lambda syntax
- Higher-order functions
- Common standard library functions

```kotlin
fun lambdaDemo() {
    // Lambda as variable
    val sum = { a: Int, b: Int -> a + b }
    println(sum(2, 3)) // 5
    
    // Higher-order function
    fun calculate(a: Int, b: Int, operation: (Int, Int) -> Int): Int {
        return operation(a, b)
    }
    
    val result = calculate(10, 5) { x, y -> x * y }
    println(result) // 50
    
    // Common functions: let, run, with, apply, also
    val message: String? = "Hello"
    message?.let { 
        // Execute block only if not null
        println(it.uppercase()) // HELLO
    }
}
```

### 10. Scope Functions
- `let`, `run`, `with`, `apply`, `also`
- Differences and use cases

```kotlin
data class Person(var name: String, var age: Int)

fun scopeFunctionsDemo() {
    val person = Person("Alice", 25)
    
    // let: null check and transform
    person.name.let { println(it.uppercase()) }
    
    // run: object configuration and computing result
    val ageAfterYear = person.run { 
        age += 1
        age // returns this value
    }
    
    // with: similar to run but as function
    with(person) {
        name = "Bob"
        age = 30
    }
    
    // apply: object configuration, returns object itself
    val updatedPerson = person.apply {
        name = "Charlie"
        age = 35
    }
    
    // also: additional actions, returns object itself
    person.also {
        println("Person before update: $it")
    }.apply {
        age = 40
    }.also {
        println("Person after update: $it")
    }
}
```

## Phase 5: Special Topics (Week 7)

### 11. Coroutines (Asynchronous Programming)
- Basic coroutine concepts
- `suspend` functions
- Coroutine builders: `launch`, `async`
- Coroutine context and dispatchers

```kotlin
import kotlinx.coroutines.*

fun coroutinesDemo() {
    // Start a coroutine
    GlobalScope.launch {
        delay(1000L) // non-blocking delay
        println("World!")
    }
    
    println("Hello,")
    Thread.sleep(2000L) // block main thread to keep JVM alive
    
    // Async/await pattern
    val result = GlobalScope.async {
        delay(1000L)
        "Coroutine result"
    }
    
    // Run blocking
    runBlocking {
        println(result.await())
    }
}
```

### 12. Interoperability with Java
- Calling Java from Kotlin
- Calling Kotlin from Java
- Handling nullability in interop
- Java-to-Kotlin converter

## Phase 6: Practical Application (Week 8+)

### 13. Building a Complete Project
- Choose a project (Android app, backend service, etc.)
- Apply all learned concepts
- Learn build tools (Gradle with Kotlin DSL)

### 14. Further Learning Paths
- Kotlin for Android development
- Kotlin multiplatform
- Ktor for web development
- Kotlin for data science

## Learning Resources

1. **Official Documentation**: [kotlinlang.org](https://kotlinlang.org/)
2. **Kotlin Koans**: Interactive exercises
3. **Books**: "Kotlin in Action", "Head First Kotlin"
4. **Online Courses**: Kotlin Bootcamp on Udacity, Kotlin courses on Udemy

## Next Steps

Would you like me to:
1. Start with detailed lessons on any specific topic?
2. Provide exercises for practice?
3. Explain any concept in more depth?
4. Help you set up your development environment?

Let me know how you'd like to proceed!