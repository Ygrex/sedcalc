#!/usr/bin/env bats

# Functional tests for sedcalc.sed
# CWD assumed to contain sedcalc.sed

# Wrapper to run sedcalc.sed as a function.
#
# Function parameters concatenated and sent to stdin for sedcalc.sed
# Example:
#	calcRunner '2*2'
# equivalent to shell command:
#	echo '2*2' | ./sedcalc.sed
calcRunner() {
	printf '%s\n' "$*" | ./sedcalc.sed
}

@test unitTests {
	run calcRunner unit-test
	[ "$status" -eq 0 ]
	[ "$output" = "OK: Unit-tests passed!" ]
}

@test additionToZero {
	run calcRunner '0+2'
	[ "$status" -eq 0 ]
	[ "$output" = 2 ]
}

@test additionOfZero {
	run calcRunner '0+2'
	[ "$status" -eq 0 ]
	[ "$output" = 2 ]
}

@test additionOfDigits {
	run calcRunner '3+2'
	[ "$status" -eq 0 ]
	[ "$output" = 5 ]
}

@test additionOfPositives {
	run calcRunner '13+29'
	[ "$status" -eq 0 ]
	[ "$output" = 42 ]
}

@test additionOfNegatives {
	run calcRunner '-13-29'
	[ "$status" -eq 0 ]
	[ "$output" = -42 ]
}

@test additionOfNegativeToPositive {
	run calcRunner '13-29'
	[ "$status" -eq 0 ]
	[ "$output" = -16 ]
}

@test additionOfPositiveToNegative {
	run calcRunner '-13+29'
	[ "$status" -eq 0 ]
	[ "$output" = 16 ]
}

@test additionOfThousands {
	run calcRunner '1234+9876'
	[ "$status" -eq 0 ]
	[ "$output" = 11110 ]
}

@test multiplyOne {
	run calcRunner '1*8'
	[ "$status" -eq 0 ]
	[ "$output" = 8 ]
}

@test multiplyWithOne {
	run calcRunner '8*1'
	[ "$status" -eq 0 ]
	[ "$output" = 8 ]
}

@test multiplyZero {
	run calcRunner '0*8'
	[ "$status" -eq 0 ]
	[ "$output" = 0 ]
}

@test multiplyWithZero {
	run calcRunner '8*0'
	[ "$status" -eq 0 ]
	[ "$output" = 0 ]
}

@test multiplyNegativeWithZero {
	run calcRunner '-8*0'
	[ "$status" -eq 0 ]
	[ "$output" = 0 ]
}

@test multiplyPositives {
	run calcRunner '8*3'
	[ "$status" -eq 0 ]
	[ "$output" = 24 ]
}

@test multiplyNegatives {
	run calcRunner '-8*-3'
	[ "$status" -eq 0 ]
	[ "$output" = 24 ]
}

@test multiplyNegativeWithPositive {
	run calcRunner '-8*3'
	[ "$status" -eq 0 ]
	[ "$output" = -24 ]
}

@test multiplyPositiveWithNegative {
	run calcRunner '8*-3'
	[ "$status" -eq 0 ]
	[ "$output" = -24 ]
}

@test multiplyHundreds {
	run calcRunner '123*456'
	[ "$status" -eq 0 ]
	[ "$output" = 56088 ]
}

@test divideByOne {
	run calcRunner '8/1'
	[ "$status" -eq 0 ]
	[ "$output" = 8 ]
}

@test divideOneByOne {
	run calcRunner '1/1'
	[ "$status" -eq 0 ]
	[ "$output" = 1 ]
}

@test divideZero {
	run calcRunner '0/3'
	[ "$status" -eq 0 ]
	[ "$output" = 0 ]
}

@test divideByZero {
	run calcRunner '3/0'
	[ "$status" -eq 1 ]
}

@test dividePositivesExactly {
	run calcRunner '21/7'
	[ "$status" -eq 0 ]
	[ "$output" = 3 ]
}

@test divideNegativesWithRemainder {
	run calcRunner '-21/-5'
	[ "$status" -eq 0 ]
	[ "$output" = 4 ]
}

@test divideNegativeByPositive {
	run calcRunner '-21/5'
	[ "$status" -eq 0 ]
	[ "$output" = -4 ]
}

@test dividePositiveByNegative {
	run calcRunner '21/-5'
	[ "$status" -eq 0 ]
	[ "$output" = -4 ]
}

@test wholeExpressionInParentheses {
	run calcRunner '(21-5+0)'
	[ "$status" -eq 0 ]
	[ "$output" = 16 ]
}

@test partOfExpressionInParentheses {
	run calcRunner '21-(5+0)'
	[ "$status" -eq 0 ]
	[ "$output" = 16 ]
}

@test expressionWithTwoParenthesesBlocks {
	run calcRunner '(21-5)/(3+2)'
	[ "$status" -eq 0 ]
	[ "$output" = 3 ]
}

@test expressionWithNestedParentheses {
	run calcRunner '(21-(8-3)*2)'
	[ "$status" -eq 0 ]
	[ "$output" = 11 ]
}

@test expressionWithWhitespaces {
	run calcRunner ' ( 21 - ( 8 - 3 )    * 2 )  '
	[ "$status" -eq 0 ]
	[ "$output" = 11 ]
}

@test evaluationOfComplexExpression {
	run calcRunner '(-1 + ((1 + 8/4) / 2 * 9 + 2) * 11) / 60'
	[ "$status" -eq 0 ]
	[ "$output" = 2 ]
}

