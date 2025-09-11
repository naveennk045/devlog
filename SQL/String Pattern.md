

MySQL String Pattern Matching Cheat Sheet 

This comprehensive cheat sheet covers all MySQL string comparison and pattern matching operators from basic to advanced usage, including LIKE operators and REGEXP/RLIKE with practical examples. 

Basic LIKE Operator Patterns 

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example <br><br>Input|Sample Data|Output|
|column LIKE <br><br>'pattern%'|Matches strings <br><br>starting with "pattern"|name LIKE <br><br>'John%'|John, Johnny, <br><br>Johnson|Matches: John, <br><br>Johnny, Johnson|
|column LIKE <br><br>'%pattern'|Matches strings <br><br>ending with "pattern"|name LIKE <br><br>'%son'|Johnson, <br><br>Peterson, <br><br>Anderson|Matches: Johnson, Peterson, <br><br>Anderson|
|column LIKE <br><br>'%pattern%'|Matches strings <br><br>containing "pattern" <br><br>anywhere|city LIKE <br><br>'%New%'|New York, New <br><br>Delhi, Newport|Matches: New York, New Delhi, <br><br>Newport|

  
  

LIKE with Single Character Wildcards

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example <br><br>Input|Sample Data|Output|
|column LIKE <br><br>'_pattern'|Matches exactly one <br><br>character followed by <br><br>pattern|code LIKE <br><br>'_AT'|CAT, BAT, <br><br>BRAT, AT|Matches: CAT, BAT (not BRAT or AT)|
|column LIKE <br><br>'pattern_'|Matches pattern <br><br>followed by exactly one character|name LIKE <br><br>'Ann_'|Anna, Anne, <br><br>Ann, Annette|Matches: Anna, <br><br>Anne (not Ann or <br><br>Annette)|
|column LIKE <br><br>'_a%'|Second character is "a", followed by any <br><br>characters|word LIKE <br><br>'_a%'|cat, bat, table, <br><br>apple|Matches: cat, bat, <br><br>table (not apple)|
|column LIKE <br><br>'a_%_%'|Starts with "a" and has at least 3 characters|name LIKE <br><br>'a_%_%'|a, ab, abc, <br><br>apple|Matches: abc, apple (not a or ab)|

  
  

NOT LIKE and ESCAPE Clauses 

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample Data|Output|
|column NOT LIKE <br><br>'pattern%'|Excludes strings <br><br>starting with <br><br>pattern|name NOT LIKE <br><br>'J%'|John, Mary, <br><br>James, Peter|Matches: Mary, <br><br>Peter (excludes <br><br>John, James)|
|column LIKE <br><br>'pattern\%' <br><br>ESCAPE '\'|Matches literal % <br><br>character using <br><br>escape[1]|discount LIKE '50\%%' <br><br>ESCAPE '\'|50%off, <br><br>50discount, <br><br>25%off|Matches: <br><br>50%off|
|column LIKE <br><br>'pattern!%' <br><br>ESCAPE '!'|Matches literal % <br><br>using custom <br><br>escape character[1]|data LIKE <br><br>'test!_%' <br><br>ESCAPE '!'|test_data, <br><br>testdata, <br><br>test%data|Matches: <br><br>test_data|

  
  

Basic REGEXP/RLIKE Patterns 

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample Data|Output|
|column REGEXP <br><br>'^pattern'|Matches strings <br><br>starting with <br><br>pattern[2] [3]|name REGEXP <br><br>'^John'|John, Johnny, <br><br>MaryJohn|Matches: John, <br><br>Johnny (not <br><br>MaryJohn)|
|column REGEXP <br><br>'pattern$'|Matches strings <br><br>ending with <br><br>pattern[2] [3]|name REGEXP <br><br>'son$'|Johnson, <br><br>Peterson, son|Matches: <br><br>Johnson, <br><br>Peterson, son|
|column REGEXP <br><br>'^pattern$'|Matches exact string (anchored at both <br><br>ends)[2] [3]|status REGEXP '^active$'|active, <br><br>inactive, <br><br>active_user|Matches: active <br><br>only|
|column REGEXP <br><br>'a.b'|Dot (.) matches any <br><br>single character[3]|code REGEXP <br><br>'a.b'|aab, axb, a1b, <br><br>ab|Matches: aab, <br><br>axb, a1b (not ab)|

  
  

REGEXP Character Classes

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample <br><br>Data|Output|
|column REGEXP <br><br>'[abc]'|Matches any single <br><br>character a, b, or c[4] [3]|grade REGEXP <br><br>'[ABC]'|A+, B-, C, <br><br>D, F|Matches: A+, B-, <br><br>C|
|column REGEXP <br><br>'[a-z]'|Matches any lowercase <br><br>letter[4] [3]|text REGEXP <br><br>'[a-z]'|ABC, abc, <br><br>123|Matches: abc|
|column REGEXP <br><br>'[0-9]'|Matches any digit[4] [3]|code REGEXP <br><br>'[0-9]'|ABC, A1B, <br><br>XYZ|Matches: A1B|
|column REGEXP <br><br>'[^0-9]'|Matches any non-digit <br><br>character[4] [3]|data REGEXP <br><br>'[^0-9]'|123, A1B, <br><br>ABC|Matches: A1B, <br><br>ABC (not 123)|

  
  

Advanced REGEXP Quantifiers 

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample <br><br>Data|Output|
|column REGEXP <br><br>'a*'|Matches zero or more <br><br>occurrences of "a"[3]|word REGEXP <br><br>'^ba*n'|bn, ban, <br><br>baan, bean|Matches: bn, ban, <br><br>baan (not bean)|
|column REGEXP <br><br>'a+'|Matches one or more <br><br>occurrences of "a"[3]|word REGEXP <br><br>'^ba+n'|bn, ban, <br><br>baan, bean|Matches: ban, baan (not bn or bean)|
|column REGEXP <br><br>'a?'|Matches zero or one <br><br>occurrence of "a"[3]|word REGEXP <br><br>'^ba?n'|bn, ban, <br><br>baan, bean|Matches: bn, ban <br><br>(not baan or bean)|
|column REGEXP <br><br>'a{3}'|Matches exactly 3 <br><br>occurrences of "a"[5]|word REGEXP <br><br>'a{3}'|a, aa, aaa, <br><br>aaaa|Matches: aaa|
|column REGEXP <br><br>'a{2,4}'|Matches between 2 and 4 occurrences of "a"[5]|word REGEXP <br><br>'a{2,4}'|a, aa, aaa, <br><br>aaaa, aaaaa|Matches: aa, aaa, <br><br>aaaa (not a or <br><br>aaaaa)|

  
  

Advanced REGEXP Features 

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample <br><br>Data|Output|
|column REGEXP <br><br>'cat\\|dog'|Matches either <br><br>"cat" or "dog"[3]|animal REGEXP <br><br>'cat\\|dog'|cat, dog, <br><br>bird, <br><br>catfish|Matches: cat, <br><br>dog, catfish|
|column REGEXP <br><br>'(ab)+'|Matches one or <br><br>more occurrences of "ab"[3]|text REGEXP <br><br>'(ab)+'|ab, abab, <br><br>aabb, ba|Matches: ab, <br><br>abab|
|column REGEXP '[[: <:]]word[[:>:]]'|Matches whole <br><br>word only[6]|text REGEXP '[[: <br><br><:]]cat[[:>:]]'|cat, cats, <br><br>catfish, <br><br>the cat|Matches: cat, <br><br>the cat (not <br><br>cats or catfish)|
|column REGEXP <br><br>'[[:alpha:]]'|Matches any <br><br>alphabetic <br><br>character[6]|data REGEXP <br><br>'[[:alpha:]]'|123, A1B, <br><br>456|Matches: A1B|
|column REGEXP <br><br>'[[:digit:]]'|Matches any digit character[6]|data REGEXP <br><br>'[[:digit:]]'|ABC, A1B, <br><br>XYZ|Matches: A1B|

  
  

String Comparison Operators

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample <br><br>Data|Output|
|column = 'value'|Exact string match <br><br>(case insensitive by default)[7]|name = 'John'|John, john, <br><br>JOHN, <br><br>Johnny|Matches: John, <br><br>john, JOHN <br><br>(not Johnny)|
|column != <br><br>'value' or <> <br><br>'value'|Not equal to <br><br>value[7]|status != 'active'|active, <br><br>inactive, <br><br>pending|Matches: <br><br>inactive, <br><br>pending|

  
  

|   |   |   |   |   |
|---|---|---|---|---|
|Operator/Pattern|Explanation|Example Input|Sample <br><br>Data|Output|
|column = BINARY 'value'|Case-sensitive exact match[8]|name = BINARY <br><br>'John'|John, john, <br><br>JOHN|Matches: John <br><br>only|
|STRCMP(col1, <br><br>col2)|Returns 0 if equal, -1 <br><br>if col1 < col2, 1 if col1 > col2[9] [8]|STRCMP('apple', <br><br>'banana')|apple vs <br><br>banana|Returns: -1|
|column IN <br><br>('val1', 'val2')|Matches any value <br><br>in the list[7]|status IN <br><br>('active', <br><br>'pending')|active, <br><br>inactive, <br><br>pending|Matches: <br><br>active, pending|
|column BETWEEN <br><br>'val1' AND <br><br>'val2'|Alphabetical range <br><br>(inclusive)[7]|name BETWEEN 'A' <br><br>AND 'D'|Alice, Bob, <br><br>Charlie, <br><br>Edward|Matches: Alice, <br><br>Bob, Charlie|

  
  

Advanced Real-World REGEXP Examples 

|   |   |   |   |   |
|---|---|---|---|---|
|Pattern|Explanation|Example Input|Sample Data|Output|
|'^[A-Z][a <br><br>z]+$'|Capitalized <br><br>word (first letter uppercase, rest <br><br>lowercase)|name REGEXP <br><br>'^[A-Z][a <br><br>z]+$'|John, JOHN, john, <br><br>John123|Matches: John only|
|'^[0-9]{3}- <br><br>[0-9]{2}-[0- <br><br>9]{4}$'|Social Security <br><br>Number format <br><br>(XXX-XX <br><br>XXXX)|ssn REGEXP <br><br>'^[0-9]{3}-[0- 9]{2}-[0-9] <br><br>{4}$'|123-45-6789, 12 <br><br>345-6789, <br><br>123456789|Matches: 123-45 <br><br>6789 only|
|'.*@.*\..*'|Basic email <br><br>pattern <br><br>(contains @ <br><br>and .)|email REGEXP <br><br>'.*@.*\..*'|user@domain.com, <br><br>invalid@, test@test|Matches: <br><br>user@domain.com|
|'^$[0-9]{3}$ <br><br>[0-9]{3}-[0- <br><br>9]{4}$'|Phone number <br><br>format (XXX) <br><br>XXX-XXXX|phone REGEXP <br><br>'^$[0-9]{3}$ <br><br>[0-9]{3}-[0-9] {4}$'|(123) 456-7890, 123 456-7890|Matches: (123) 456 7890 only|

  
  
