
## Regex Basics - The Building Blocks

### 1. **Literal Characters**
```regex
cat
```
Matches exactly: "cat"  
**Example**: "concatenate" → matches "cat" inside it

### 2. **Character Classes - Match ANY of these**
```regex
[aeiou]      # Any vowel
[0-9]        # Any digit (0,1,2,...,9)
[a-z]        # Any lowercase letter
[A-Z]        # Any uppercase letter
[a-zA-Z]     # Any letter
[abc]        # Either a, b, or c
```
**Example**: `[aeiou]` in "hello" → matches "e" and "o"

### 3. **Quantifiers - How many times?**
```regex
a+       # One or more a's (a, aa, aaa, ...)
a*       # Zero or more a's ("", a, aa, ...)
a?       # Zero or one a ("" or a)
a{3}     # Exactly 3 a's (aaa)
a{2,4}   # Between 2-4 a's (aa, aaa, aaaa)
```
**Example**: `a+` in "baaad" → matches "aaa"

### 4. **Anchors - Position matters**
```regex
^start   # Must start with "start"
end$     # Must end with "end"
^exact$  # Exact match "exact"
```

### 5. **Wildcards and Escaping**
```regex
.        # Any single character (except newline)
\.       # Literal dot (escape with \)
\\       # Literal backslash
```

## Common Patterns Cheat Sheet

### Email Validation
```regex
^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$
```
- `^` start
- `[A-Za-z0-9._%+-]+` username (one or more)
- `@` literal @
- `[A-Za-z0-9.-]+` domain name
- `\.` literal dot
- `[A-Za-z]{2,}$` TLD (2+ letters, then end)

### Phone Numbers
```regex
^\+?[0-9]{7,15}$        # Simple international
^\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}$  # US format
```

