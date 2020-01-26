# sedcalc

## Description

sedcalc is an arithmetic integer calculator written in GNU sed.

Supported features:
* Positive and negative integers arithmetic.
* Four operators: +, -, \*, / (integer division)
* Grouping with parentheses: (, )
* Embedded self-tests activated by special input 'unit-test'

Requirements:
* GNU sed required to run. Tested on v4.7.
* BATS (Bash test framework) required to run functional tests. Tested with v1.2.0.

Usage:
    echo '3 * 6 / 2 - (2 + 7)' | ./sedcalc.sed

## Tests

### Unit tests
Activated by passing 'unit-test' input:
    $ echo unit-test | ./sedcalc.sed 
    OK: Unit-tests passed!

### Functional tests
Activated by running BATS script:
    $ ./test.sh 
     ✓ unitTests
     ✓ additionToZero
     ✓ additionOfZero
     ✓ additionOfDigits
     ✓ additionOfPositives
     ✓ additionOfNegatives
     ✓ additionOfNegativeToPositive
     ✓ additionOfPositiveToNegative
     ✓ additionOfThousands
     ✓ multiplyOne
     ✓ multiplyWithOne
     ✓ multiplyZero
     ✓ multiplyWithZero
     ✓ multiplyNegativeWithZero
     ✓ multiplyPositives
     ✓ multiplyNegatives
     ✓ multiplyNegativeWithPositive
     ✓ multiplyPositiveWithNegative
     ✓ multiplyHundreds
     ✓ divideByOne
     ✓ divideOneByOne
     ✓ divideZero
     ✓ divideByZero
     ✓ dividePositivesExactly
     ✓ divideNegativesWithRemainder
     ✓ divideNegativeByPositive
     ✓ dividePositiveByNegative
     ✓ wholeExpressionInParentheses
     ✓ partOfExpressionInParentheses
     ✓ expressionWithTwoParenthesesBlocks
     ✓ expressionWithNestedParentheses
     ✓ expressionWithWhitespaces
     ✓ evaluationOfComplexExpression
    
    33 tests, 0 failures

## Development

### Overview

There are a few concepts leveraged in the code:
* all script runs in a single sed execution cycle
* call stack stored in the hold space
* subroutine convention:
  * top-most line in a call stack refers to the return address (label)
  * subroutine input passed in the pattern space
  * subroutine output passed in the pattern space too
  * jumping to a subroutine gets done with branching commands: `b`, `t` or `T`
  * returning from subroutine gets done with a trampoline (see below)
* whole code structured in subroutines
* entry point is `main` subroutine
* common trampoline subroutine `callbackTrampoline` conventionally used (see above)
* common exception handler subroutine `errorHalt` conventionally used to halt execution

### Style

Should be all clear from the script, it is long enough to have plenty of examples.

### Arithmetic Algorithms

In general the path of implementation can be tracked through unit-tests order
in `unitTestMain`. It goes from primitives to complex problems.

#### Addition and Subtraction

Implemented for two integers on top of increment/decrement by one functions
calling them in a loop, so that `4+3` would go in loop like this:
    4+3 <- input
    5+2
    6+1
    7+0 <- stop condition
    7 <- result

#### Multiplication

Implemented for two positive integers on top of addition function calling it
in a loop, so that `4*3` would go in loop like this:
    4*3 <- input, it gets transformed as follows

    0+4 <- this is passed down to addition function
    4   <- this is multiplier
    3   <- loop counter, how many times more to perform the addition

    4+4
    4
    2

    8+4
    4
    1   <- stop condition, addition result is to be returned

#### Division

Integer division only implemented. Seems trivial to extend to arbitrary
precision numbers if ever needed.
Implemented for two positive integers on top of subtraction calling it in
a loop, so that `9/3` would go in loop like this:
    9/3 <- input

    9-3 <- this is passed down to subtraction function
    3   <- divisor
    0   <- number of subtractions done so far

    6-3
    3
    1

    3-3
    3
    2

    0-3 <- 0 remainder here is a stop condition
    3
    3   <- result of the division

#### Parentheses Reduction

Parentheses reduction is the first operation on evaluating expressions.
It reduces by finding the inner-most parentheses block (which contains no
nested parentheses), passing it down to evaluation function as a simple
expression, and substitutin the parentheses with the evaluated result.

So that it goes this way:
    (1+(2+3(4+5))) <- input

    4+5 <- evaluate this
    (1+(2+3_(4+5)_)) <- and put here

    (1+(2+3+9)) <- transformed input after the first reduction step

    2+3+9 <- evaluate this
    (1+_(2+3+9)_) <- and put result here

    (1+14) <- transformed input after the second reduction step

And after the last round it sends result back to the caller.

#### Simple Expression Evaluator

The input assumed to have no parentheses groups, so that operators affinity
define order of execution. The evaluator first looks for `*` and `/` operators,
if none found, then it tries to find `+` or `-` operators.
Once any found, the expression of two operands gets evaluated with one of
functions described above, result gets substituted into the original
expression and goes through the evaluator again.

Simple demonstration of the flow is:
    2+3*4/2 <- input

    3*4 <- is found first, goes to the multiplication evaluator
    2+_3*4_/2 <- result will be placed here

    2+12/2 <- simplified input

So that in three loops the whole expression gets evaluated.

## Contacts and License

Distributed under terms of BSD license, available in LICENSE file.
Author is @Ygrex <ygrex@ygrex.ru>.

