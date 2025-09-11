**Comprehensive SQL Functions Cheat Sheet 

Below is a categorized listing of all major built-in SQL functions, organized by topic. Each table shows function names and brief descriptions. 

String Functions

|   |   |
|---|---|
|Function|Description|
|ASCII|Returns ASCII code of first character|
|CHAR(), CHARACTER()|Returns character for given code point|
|CHAR_LENGTH, LENGTH|Returns string length (in characters or bytes)|
|CONCAT(), CONCAT_WS|Concatenates strings (with optional separator)|
|FIELD()|Returns index of value in list|
|FIND_IN_SET()|Returns position of string in comma-separated list|
|FORMAT()|Formats number or date using format string|
|INSERT()|Inserts substring into string|
|INSTR(), LOCATE()|Returns position of substring|
|LCASE(), LOWER|Converts string to lowercase|
|LEFT(), RIGHT()|Extracts specified number of characters from start/end|
|LPAD(), RPAD|Pads string on left/right to given length|
|LTRIM(), RTRIM, TRIM|Removes leading/trailing spaces|
|MID(), SUBSTR(), SUBSTRING()|Extracts substring starting at specified position|
|SUBSTRING_INDEX()|Returns substring before Nth occurrence of delimiter|
|REPEAT()|Repeats string N times|
|REPLACE()|Replaces occurrences of substring|
|REVERSE()|Reverses string|
|SPACE()|Returns string of N space characters|
|STRCMP()|Compares two strings|
|UCASE(), UPPER|Converts string to uppercase|

  
  

Numeric Functions 

|   |   |
|---|---|
|Function|Description|
|ABS()|Absolute value|
|CEIL(), FLOOR()|Rounds up/down|
|POWER(), EXP()|Exponentiation|
|SQRT()|Square root|
|ROUND()|Rounds to specified decimals|
|MOD()|Modulo (remainder)|
|SIGN()|Sign of number|
|LEAST(), GREATEST()|Smallest/largest of arguments|
|SIN(), COS(), TAN(), COT()|Trigonometric functions|
|DEGREES(), RADIANS()|Converts between radians and degrees|
|LOG(), LN(), LOG2(), LOG10()|Logarithms|
|RAND()|Random number|

  
  

Date & Time Functions

|   |   |
|---|---|
|Function|Description|
|CURDATE(), CURRENT_DATE|Current date (YYYY-MM-DD or <br><br>YYYYMMDD)|
|CURTIME(), CURRENT_TIME|Current time (hh:mm:ss or hhmmss)|
|NOW(), CURRENT_TIMESTAMP|Current date and time|
|SYSDATE()|Execution time (nonconstant)|
|ADDDATE(), DATE_ADD|Add interval to date|
|SUBDATE(), DATE_SUB|Subtract interval from date|
|ADDTIME(), SUBTIME|Add/subtract time|
|DATEDIFF()|Difference between dates (in days)|
|TIMEDIFF()|Difference between times|
|TIMESTAMP(), TIMESTAMPADD(), TIMESTAMPDIFF()|Timestamp arithmetic|
|DATE(), EXTRACT()|Extract date part or component|
|DATE_FORMAT()|Format date using format specifiers|
|STR_TO_DATE()|Parse string into date/time|
|DAY(), DAYOFMONTH(), DAYNAME(), DAYOFWEEK(), <br><br>DAYOFYEAR()|Day functions|

  
  

|                                             |                                          |
| ------------------------------------------- | ---------------------------------------- |
| Function                                    | Description                              |
| WEEK(), WEEKDAY(), WEEKOFYEAR(), YEARWEEK() | Week and year-week functions             |
| MONTH(), MONTHNAME(), QUARTER()             | Month and quarter functions              |
| YEAR(), YEARWEEK()                          | Year or year-week                        |
| HOUR(), MINUTE(), SECOND()                  | Hour, minute, second                     |
| MICROSECOND()                               | Microsecond extraction                   |
| MAKEDATE(), MAKETIME()                      | Build date/time from components          |
| LAST_DAY()                                  | Last day of month                        |
| UNIX_TIMESTAMP(), FROM_UNIXTIME()           | Unix epoch conversion                    |
| TO_DAYS(), TO_SECONDS()                     | Convert date/time to day or second count |
| CONVERT_TZ()                                | Time zone conversion                     |
| GET_FORMAT()                                | Returns format string for date/time      |

  
  

Aggregate Functions 

|   |   |
|---|---|
|Function|Description|
|COUNT(), COUNT(DISTINCT)|Count rows or distinct values|
|SUM()|Sum of values|
|AVG()|Average of values|
|MIN(), MAX()|Minimum or maximum|
|STD(), STDDEV_POP(), STDDEV_SAMP()|Population/sample standard deviation|
|VAR_POP(), VAR_SAMP(), VARIANCE()|Population/sample variance|
|BIT_AND(), BIT_OR(), BIT_XOR()|Bitwise aggregates|
|GROUP_CONCAT()|Concatenate group values into string|
|JSON_ARRAYAGG(), JSON_OBJECTAGG()|Aggregate result set into JSON array/object|

  
  

Flow Control & Conversion

|   |   |
|---|---|
|Function|Description|
|CASE … WHEN … THEN|Conditional branching|
|IF(), IFNULL(), NULLIF(), COALESCE()|Conditional and null handling|
|CAST(), CONVERT()|Data type conversion|
|CONV()|Convert numbers between bases|

  
  

System & Metadata

|   |   |
|---|---|
|Function|Description|
|DATABASE()|Returns current database|
|USER(), CURRENT_USER(), SESSION_USER(), SYSTEM_USER()|User information|
|VERSION()|Server version|
|CONNECTION_ID()|Client connection ID|

  
  

This cheat sheet covers every built-in SQL function across string, numeric, date-time, aggregation, control-flow, and system categories for quick reference. 

⁂**