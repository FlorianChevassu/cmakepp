# CMake Expression Syntax

_This Section is currently just a draft_


## Motivation

CMake's syntax is not sexy. It does not allow the developer rudimentary constructs which almost all other languages have.  But because CMake's language is astonishingly flexible I was able to create a lexer and parser and interpreter for a custom 100 % compatible syntax which (once "JIT compiled") is also fast.


## Example

The easiest way to introduce the new syntax and its usefulness is by example. So here it is (Note that these example are actually executed. Their syntax is correct)

```cmake
expr("{a:a}") => {"a":"a"}

# use expr to compile and evaluate an expression:
expr(ab c) => `abc`
## set a to 1
expr($a = 1)
assert("${a}" EQUAL 1)

## unset a
expr("$a = null")
assert(NOT SET a)


## create an object
expr($['a'] = { "last_name":Becker, first_name:'Tobias' })
assertf({a.last_name} STREQUAL "Becker")
assertf({a.first_name} STREQUAL "Tobias")


## call a function
expr(message("hello world")) # prints `hello world`

## call nested functions and assign a variable and print the result a function with first parameter binding
function(say_my_name)
    return("TobiAs")
endfunction()
expr(message( ($a = say_my_name()::string_to_lower())::string_to_upper())) # prints `TOBIAS` 
assert("${a}" STREQUAL "tobias")


## more examples...



```



## The Expression Language Definition

I mixed several indices and concepts from different languages which I like.  I am not a professional language designer so some decisions might seem strange but I am actually quite proud of how it turned out:


The examples are not cmake strings. They need to be escaped again in some cases
```
## the forbidden chars are used by the tokenizer and using them will cause the world to explode. They are all valid ASCII codes < 32 and > 0 
<forbidden char> ::=  SOH | NAK | US | STX | ETX | GS | FS | SO  
<escapeable char> :: = "\" """ "'"  
<free char> ::= <ascii char>  /  <forbidden char> / <escapablechar> 
<escaped char> 
<quoted string content> ::= <<char>|"\" <escaped char>>* 

## strings 
<double quoted string> ::= """ <quoted string content> """
    expr("\"\"")    => ``
    expr("\"hello\"")   => `hello`
    expr("\"\\' single quote\"")    => `' single quote`
    expr"\"\\\" double quote\"" => `" double quote`
    expr("\\ backslash")    => `\ backslash`

<double quoted string> ::= "'" <quoted string content> "'"
    expr("''")    =>  ``
    expr('')    =>  ``
    expr("'hello'")   =>  `hello`
    expr('hello')   =>  `hello`
    expr("'\\' single quote'")    =>  `' single quote`
    expr("'\\\" double quote'")
    expr('\\ backslash')
    expr('\" double quote')

<unquoted string> ::= 
    ...
<separated string> ::= 
    ""
    "hello world"
    ...

<string> ::= <double quoted string> | <single quoted string> | <unquoted string> | <separated string>

## every literal is a const string 
## some unquoted strings have a special meaning
## quoted strings are always strings even if their content matches one
## of the specialized definitions
<number> ::= /0|[1-9][0-9]*/
    number
        0
        1
        912930
    NOT number:
        01
        "'1'" 
        "\"1\""

<bool> ::= "true" | "false"
    bool
        true
        false
    NOT bool
        "'true'"
        "\"false\""

<null> ::= "null"
    null
        null
    NOT null
        "'null'"

<literal> ::= <string>|<number>|<bool>|<null>
    valid literal
        "hello world"
        123
        "'123'"
        true
        null
        ""
        abc




<value> ::= <paren>|<value dereference>|<value reference>|<ellipsis>|<literal>|<interpolation>|<bind call>|<call>|<list>|<object>|<scope variable>|<indexation>|<navigation>

## an interpolation combines multiple values into a single value
<interpolation> ::= <value> * 
    expr("a" "b" "c") => `abc`

<expression> ::= <assign>|<value> 

```



## Performance

Here is some performance data for the cmake expression syntax


Expression | Token Count | Ast Nodes | Compile Time | Cached Compile Time |  Execution Time | Compile Statements
`$the_object.e[0,1]...['a']` | 15 | 9 | 420 ms | 5 ms | 22




## Still Open

* derefernce 
* address of
* out value
    - `$` as result indicator
    - 
* lvalue range
* lvalue range assign
* lvalue range assign ellipsis
* lambda
* statements
* closures
* force path existance
* operators
    - *math* CMake needs a basic math system to be inplace `math(EXPR)` is really, really bad. 
        + `+`
        + `-`
        + `*`
        + `/`
        + `%`
    - string 
    - any
        + `??` null coalescing operator
    


## Known Issues



## Future Work

When the syntax is complete and this feature works well the next step is to incorporate it into CMake using C code.  This will make everything much, much faster and will get rid of those hideous generator expressions.  Maybe even the whole cmake script language itself.