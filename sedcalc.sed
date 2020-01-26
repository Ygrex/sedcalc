#!/bin/sed -Enf

# Arithmetic calculator written in GNU sed.
#
# Supported features:
#	Positive and negative integers arithmetic.
#	Four operators: +, -, *, / (integer division)
#	Grouping with parentheses: (, )
#	Embedded self-tests activated by special input 'unit-test'
#
# Requirements:
#	GNU sed required to run.
#
# Usage:
#	echo '3 * 6 / 2 - (2 + 7)' | ./sedcalc.sed

b main

# {{{ errorHalt: dump pattern and hold spaces, quit
:errorHalt
	i DD: Pattern space:
	l
	i DD: Hold space:
	x ; l
	Q1
# }}}

# {{{ callbackTrampoline: return execution to the top label in stack
# Stack is kept in the hold space.
# Each line terminates with newline character and corresponds to a label.
# The topmost label gets popped off the stack and execution branches to it.
# Going to the label resets conditional flag (next `t` will not be followed).
# This way the convention to call a function is:
#   1. to push a return label to stack, it is to be \n terminated
#   2. add the label into this trampoline
#   3. return from the called function by branching to this trampoline
#   4. the hold space is not used other than keeping stack
# Example to call the subroutine:
#   :caller
#     x ; s/^/caller_after_subroutine\n/ ; x
#     b subroutine
#     :caller_after_subroutine
# Example subroutine:
#   :subroutine
#     b callbackTrampoline
:callbackTrampoline
	t callbackTrampoline
	x
	s/^main_after_normalizeInput\n//
		T callbackTrampoline_step_01
		x
		b main_after_normalizeInput
	:callbackTrampoline_step_01
	s/^unitTestMain_after_normalizeInput\n//
		T callbackTrampoline_step_02
		x
		b unitTestMain_after_normalizeInput
	:callbackTrampoline_step_02
	s/^unitTestMain_after_incrementDigit\n//
		T callbackTrampoline_step_03
		x
		b unitTestMain_after_incrementDigit
	:callbackTrampoline_step_03
	s/^unitTestMain_after_decrementDigit\n//
		T callbackTrampoline_step_04
		x
		b unitTestMain_after_decrementDigit
	:callbackTrampoline_step_04
	s/^unitTestMain_after_nineOutZeroes\n//
		T callbackTrampoline_step_05
		x
		b unitTestMain_after_nineOutZeroes
	:callbackTrampoline_step_05
	s/^unitTestMain_after_zeroOutNines\n//
		T callbackTrampoline_step_06
		x
		b unitTestMain_after_zeroOutNines
	:callbackTrampoline_step_06
	s/^incrementInteger_after_zeroOutNines\n//
		T callbackTrampoline_step_07
		x
		b incrementInteger_after_zeroOutNines
	:callbackTrampoline_step_07
	s/^incrementInteger_after_incrementDigit\n//
		T callbackTrampoline_step_08
		x
		b incrementInteger_after_incrementDigit
	:callbackTrampoline_step_08
	s/^unitTestMain_after_incrementInteger\n//
		T callbackTrampoline_step_09
		x
		b unitTestMain_after_incrementInteger
	:callbackTrampoline_step_09
	s/^decrementInteger_after_nineOutZeroes\n//
		T callbackTrampoline_step_10
		x
		b decrementInteger_after_nineOutZeroes
	:callbackTrampoline_step_10
	s/^decrementInteger_after_decrementDigit\n//
		T callbackTrampoline_step_11
		x
		b decrementInteger_after_decrementDigit
	:callbackTrampoline_step_11
	s/^unitTestMain_after_decrementInteger\n//
		T callbackTrampoline_step_12
		x
		b unitTestMain_after_decrementInteger
	:callbackTrampoline_step_12
	s/^unitTestMain_after_strictAddIntegers\n//
		T callbackTrampoline_step_13
		x
		b unitTestMain_after_strictAddIntegers
	:callbackTrampoline_step_13
	s/^unitTestMain_after_strictSubtractIntegers_positive\n//
		T callbackTrampoline_step_14
		x
		b unitTestMain_after_strictSubtractIntegers_positive
	:callbackTrampoline_step_14
	s/^unitTestMain_after_strictSubtractIntegers_negative\n//
		T callbackTrampoline_step_15
		x
		b unitTestMain_after_strictSubtractIntegers_negative
	:callbackTrampoline_step_15
	s/^strictAddIntegers_after_incrementInteger\n//
		T callbackTrampoline_step_16
		x
		b strictAddIntegers_after_incrementInteger
	:callbackTrampoline_step_16
	s/^strictAddIntegers_after_decrementInteger\n//
		T callbackTrampoline_step_17
		x
		b strictAddIntegers_after_decrementInteger
	:callbackTrampoline_step_17
	s/^strictSubtractIntegers_after_decrementInteger_1\n//
		T callbackTrampoline_step_18
		x
		b strictSubtractIntegers_after_decrementInteger_1
	:callbackTrampoline_step_18
	s/^strictSubtractIntegers_after_decrementInteger_2\n//
		T callbackTrampoline_step_19
		x
		b strictSubtractIntegers_after_decrementInteger_2
	:callbackTrampoline_step_19
	s/^unitTestMain_after_addIntegers_two_negative\n//
		T callbackTrampoline_step_20
		x
		b unitTestMain_after_addIntegers_two_negative
	:callbackTrampoline_step_20
	s/^unitTestMain_after_addIntegers_first_negative\n//
		T callbackTrampoline_step_21
		x
		b unitTestMain_after_addIntegers_first_negative
	:callbackTrampoline_step_21
	s/^unitTestMain_after_addIntegers_second_negative\n//
		T callbackTrampoline_step_22
		x
		b unitTestMain_after_addIntegers_second_negative
	:callbackTrampoline_step_22
	s/^invertInteger\n//
		T callbackTrampoline_step_23
		x
		b invertInteger
	:callbackTrampoline_step_23
	s/^unitTestMain_after_invertInteger\n//
		T callbackTrampoline_step_24
		x
		b unitTestMain_after_invertInteger
	:callbackTrampoline_step_24
	s/^unitTestMain_after_strictMultiplyIntegers\n//
		T callbackTrampoline_step_25
		x
		b unitTestMain_after_strictMultiplyIntegers
	:callbackTrampoline_step_25
	s/^strictMultiply_after_addIntegers\n//
		T callbackTrampoline_step_26
		x
		b strictMultiply_after_addIntegers
	:callbackTrampoline_step_26
	s/^strictMultiply_after_decrementInteger\n//
		T callbackTrampoline_step_27
		x
		b strictMultiply_after_decrementInteger
	:callbackTrampoline_step_27
	s/^unitTestMain_after_strictDivideIntegers_exactly\n//
		T callbackTrampoline_step_28
		x
		b unitTestMain_after_strictDivideIntegers_exactly
	:callbackTrampoline_step_28
	s/^unitTestMain_after_strictDivideIntegers_remainder\n//
		T callbackTrampoline_step_29
		x
		b unitTestMain_after_strictDivideIntegers_remainder
	:callbackTrampoline_step_29
	s/^strictDivideIntegers_loop\n//
		T callbackTrampoline_step_30
		x
		b strictDivideIntegers_loop
	:callbackTrampoline_step_30
	s/^strictDivideIntegers_after_addIntegers\n//
		T callbackTrampoline_step_31
		x
		b strictDivideIntegers_after_addIntegers
	:callbackTrampoline_step_31
	s/^unitTestMain_after_multiplyDivideIntegers_divideNegatives\n//
		T callbackTrampoline_step_32
		x
		b unitTestMain_after_multiplyDivideIntegers_divideNegatives
	:callbackTrampoline_step_32
	s/^unitTestMain_after_multiplyDivideIntegers_divideMixedSigns\n//
		T callbackTrampoline_step_33
		x
		b unitTestMain_after_multiplyDivideIntegers_divideMixedSigns
	:callbackTrampoline_step_33
	s/^unitTestMain_after_multiplyDivideIntegers_multiplyMixedSigns\n//
		T callbackTrampoline_step_34
		x
		b unitTestMain_after_multiplyDivideIntegers_multiplyMixedSigns
	:callbackTrampoline_step_34
	s/^unitTestMain_after_strictMultiplyDivideIntegers_divide\n//
		T callbackTrampoline_step_35
		x
		b unitTestMain_after_strictMultiplyDivideIntegers_divide
	:callbackTrampoline_step_35
	s/^unitTestMain_after_strictMultiplyDivideIntegers_multiply\n//
		T callbackTrampoline_step_36
		x
		b unitTestMain_after_strictMultiplyDivideIntegers_multiply
	:callbackTrampoline_step_36
	s/^reduceParentheses_after_evaluateLinearExpression\n//
		T callbackTrampoline_step_37
		x
		b reduceParentheses_after_evaluateLinearExpression
	:callbackTrampoline_step_37
	s/^unitTestMain_after_evaluateLinearExpression_threeAdditions\n//
		T callbackTrampoline_step_38
		x
		b unitTestMain_after_evaluateLinearExpression_threeAdditions
	:callbackTrampoline_step_38
	s/^evaluateLinearExpression\n//
		T callbackTrampoline_step_39
		x
		b evaluateLinearExpression
	:callbackTrampoline_step_39
	s/^unitTestMain_after_evaluateLinearExpression_threeMultDiv\n//
		T callbackTrampoline_step_40
		x
		b unitTestMain_after_evaluateLinearExpression_threeMultDiv
	:callbackTrampoline_step_40
	s/^unitTestMain_after_evaluateLinearExpression_addMultSubDiv\n//
		T callbackTrampoline_step_41
		x
		b unitTestMain_after_evaluateLinearExpression_addMultSubDiv
	:callbackTrampoline_step_41
	s/^evaluateLinearExpression_after_addIntegers\n//
		T callbackTrampoline_step_42
		x
		b evaluateLinearExpression_after_addIntegers
	:callbackTrampoline_step_42
	s/^evaluateLinearExpression_after_multiplyDivideIntegers\n//
		T callbackTrampoline_step_43
		x
		b evaluateLinearExpression_after_multiplyDivideIntegers
	:callbackTrampoline_step_43
	s/^unitTestMain_after_reduceParentheses_single\n//
		T callbackTrampoline_step_44
		x
		b unitTestMain_after_reduceParentheses_single
	:callbackTrampoline_step_44
	s/^unitTestMain_after_reduceParentheses_nested\n//
		T callbackTrampoline_step_45
		x
		b unitTestMain_after_reduceParentheses_nested
	:callbackTrampoline_step_45
	s/^unitTestMain_after_evaluateExpression\n//
		T callbackTrampoline_step_46
		x
		b unitTestMain_after_evaluateExpression
	:callbackTrampoline_step_46
	s/^main_after_evaluateExpression\n//
		T callbackTrampoline_step_47
		x
		b main_after_evaluateExpression
	:callbackTrampoline_step_47
	:callbackTrampoline_halt
		i goBack Unexpected callback!
		b errorHalt
# }}}

# {{{ incrementDigit: increment 1st digit on a line by 1 (modular 10)
# Assuming the line begins with a digit, increment it by one in modular 10.
# Example input : 898989 abc
# Example result: 998989 abc
:incrementDigit
	t incrementDigit
	s/^9/0/
	t callbackTrampoline
	s/^8/9/
	s/^7/8/
	s/^6/7/
	s/^5/6/
	s/^4/5/
	s/^3/4/
	s/^2/3/
	s/^1/2/
	s/^0/1/
	t callbackTrampoline
	i increaseFirstLine unexpected input!
	b errorHalt
# }}}

# {{{ decrementDigit: decremet 1st digit on a line by 1 (modular 10)
# Assuming the line begins with a digit, decrement it by one in modular 10.
# Example input : 898989 abc
# Example result: 798989 abc
:decrementDigit
	t decrementDigit
	s/^0/9/
	t callbackTrampoline
	s/^1/0/
	s/^2/1/
	s/^3/2/
	s/^4/3/
	s/^5/4/
	s/^6/5/
	s/^7/6/
	s/^8/7/
	s/^9/8/
	t callbackTrampoline
	i decrementDigit unexpected input!
	b errorHalt
# }}}

# {{{ zeroOutNines: translate 0 to 9 in the first word on a line
# Assuming the line begins with an integer, convert all nines in it to zeroes.
# Example input : 898989 abc
# Example result: 808080 abc
:zeroOutNines
	t zeroOutNines
	s/^([[:digit:]]*)9([[:digit:]]*)\b/\10\2/
	t zeroOutNines
	b callbackTrampoline
# }}}

# {{{ nineOutZeroes: translate 9 to 0 in the first word on a line
# Assuming the line begins with an integer, convert all zeroes in it to nines.
# Example input : 808080 abc
# Example result: 898989 abc
:nineOutZeroes
	t nineOutZeroes
	s/^([[:digit:]]*)0([[:digit:]]*)\b/\19\2/
	t nineOutZeroes
	b callbackTrampoline
# }}}

# {{{ incrementInteger: increment integer modulus by 1
# Assuming the line begins with an integer, increment it by one.
# Example input : 898989 abc
# Example result: 898990 abc
:incrementInteger
	t incrementInteger
	# line is of three pieces here /^([[:digit:]]*)([^9])([9]*)\b/
	# \1 is to stay untouched
	# \2 is to be incremented
	# \3 is to be zeroed out
	# if it is all nines, just append 0 and it is in compatible form now
	s/^9+\b/0&/
	t incrementInteger
	# divide pieces in three lines, re-order them backwards:
	s/^(-?[[:digit:]]*)([0-8])([9]*)\b/\3\n\2\n\1\n/
	T incrementInteger_halt
	x ; s/^/incrementInteger_after_zeroOutNines\n/ ; x
	b zeroOutNines
	:incrementInteger_after_zeroOutNines
	# trailing nines are zeroed out, shift them to the 3rd line
	s/^([^\n]*)\n([^\n]*)\n([^\n]*)\n/\2\n\3\n\1\n/
	T incrementInteger_halt
	x ; s/^/incrementInteger_after_incrementDigit\n/ ; x
	b incrementDigit
	:incrementInteger_after_incrementDigit
	# middle piece is incremented, assemble the result
	s/^([^\n]*)\n([^\n]*)\n([^\n]*)\n/\2\1\3/
	T incrementInteger_halt
	b callbackTrampoline
	:incrementInteger_halt
		i incrementInteger unexpected input!
		b errorHalt
# }}}

# {{{ decrementInteger: decrement integer modulus by 1
# Assuming the line begins with an integer, decrement it by one.
# Example input : 898989 abc
# Example result: 898988 abc
# Returns zero if input is zero.
:decrementInteger
	t decrementInteger
	# just quit if it is all zeroes
	s/^0+\b/0/
	t callbackTrampoline
	# line is of three pieces here /^([[:digit:]]*)([1-9])([0]*)\b/
	# \1 is to stay untouched
	# \2 is to be decremented
	# \3 is to be nined out
	# divide pieces in lines, re-order backwards
	s/^(-?[[:digit:]]*)([1-9])([0]*)\b/\3\n\2\n\1\n/
	T decrementInteger_halt
	x ; s/^/decrementInteger_after_nineOutZeroes\n/ ; x
	b nineOutZeroes
	:decrementInteger_after_nineOutZeroes
	# trailing zeroes converted to nines, put the piece to the 3rd line
	s/^([^\n]*)\n([^\n]*)\n([^\n]*)\n/\2\n\3\n\1\n/
	T decrementInteger_halt
	x ; s/^/decrementInteger_after_decrementDigit\n/ ; x
	b decrementDigit
	:decrementInteger_after_decrementDigit
	# middle piece is decremented, assemble the result
	s/^([^\n]*)\n([^\n]*)\n([^\n]*)\n/\2\1\3/
	T decrementInteger_halt
	# chop off leading zeroes
	s/^0+\b/0/
	s/^(-?)0+([1-9])/\1\2/
	b callbackTrampoline
	:decrementInteger_halt
		i decrementInteger unexpected input!
		b errorHalt
# }}}

# {{{ strictAddIntegers: add two integers in strict format
# Assuming addition of integers in a strict form A+B
:strictAddIntegers
	t strictAddIntegers
	# N + 0 is a counter stop condition
	s/^([[:digit:]]+)\+0+\b/\1/
	t callbackTrampoline
	x ; s/^/strictAddIntegers_after_incrementInteger\n/ ; x
	b incrementInteger
	:strictAddIntegers_after_incrementInteger
	# left hand operand is incremented,
	# reorder operands and decrement the other one
	s/^([[:digit:]]+)\+([[:digit:]]+)\b/\2+\1/
	T strictAddIntegers_halt
	x ; s/^/strictAddIntegers_after_decrementInteger\n/ ; x
	b decrementInteger
	:strictAddIntegers_after_decrementInteger
	# restore the original order of operands
	s/^([[:digit:]]+)\+([[:digit:]]+)\b/\2+\1/
	t strictAddIntegers
	:strictAddIntegers_halt
		i strictAddIntegers unexpected input!
		b errorHalt
# }}}

# {{{ strictSubtractIntegers: subtract two integers in strict format
# Assuming subtraction of integers in a strict form A-B
:strictSubtractIntegers
	t strictSubtractIntegers
	# N - 0 is a counter stop condition
	s/^([[:digit:]]+)-0+\b/\1/
	t callbackTrampoline
	# 0 - N is a counter stop as well
	s/^-?0+(-[[:digit:]]+)\b/\1/
	t callbackTrampoline
	x ; s/^/strictSubtractIntegers_after_decrementInteger_1\n/ ; x
	b decrementInteger
	:strictSubtractIntegers_after_decrementInteger_1
	# left hand operand is decremented,
	# reorder operands and decrement the other one as well
	s/^([[:digit:]]+)-([[:digit:]]+)\b/-\2+\1/
	T strictSubtractIntegers_halt
	x ; s/^/strictSubtractIntegers_after_decrementInteger_2\n/ ; x
	b decrementInteger
	:strictSubtractIntegers_after_decrementInteger_2
	# restore the original order of operands
	s/^-([[:digit:]]+)\+([[:digit:]]+)\b/\2-\1/
	t strictSubtractIntegers
	:strictSubtractIntegers_halt
		i strictSubtractIntegers unexpected input!
		b errorHalt
# }}}

# {{{ invertInteger: multiply by -1
:invertInteger
	t invertInteger
	# do not invert zero
	s/^0+\b/&/
	t callbackTrampoline
	s/^-([[:digit:]]+)\b/\1/
	t callbackTrampoline
	s/^/-/
	b callbackTrampoline
# }}}

# {{{ addIntegers: add two integers
# Assuming addition or subtraction in one of the following forms:
#   A+B, -A+B, A-B, -A-B, A+-B (equals to A-B)
:addIntegers
	t addIntegers
	# N + 0 is a counter stop condition
	s/^(-?[[:digit:]]+)\+-?0+\b/\1/
	t callbackTrampoline
	# convert to a simple subtraction if suitable
	s/^([[:digit:]]+)\+?-([[:digit:]]+)\b/\1-\2/
	s/^-([[:digit:]]+)\+([[:digit:]]+)\b/\2-\1/
	t strictSubtractIntegers
	# just branch to strict addition if it is in strict form
	s/^([[:digit:]]+)\+([[:digit:]]+)\b/&/
	t strictAddIntegers
	# otherwise the problem is to add moduli and attach a minus sign
	s/^-([[:digit:]]+)\+?-([[:digit:]]+)\b/\1+\2/
	x ; s/^/invertInteger\n/ ; x
	b strictAddIntegers
	:addIntegers_halt
		i addIntegers unexpected input!
		b errorHalt
# }}}

# {{{ strictMultiplyIntegers: muptiply integers
# Input: A*B
:strictMultiplyIntegers
	t strictMultiplyIntegers
	# divide pieces in lines, start accumulator with 0
	s/^([[:digit:]]+)\*([[:digit:]]+)\b/0\n\1\n\2\n/
	T strictMultiplyIntegers_halt
	:strictMultiplyIntegers_loop
	t strictMultiplyIntegers_loop
	# counter stop condition
	s/^([^\n]+)\n[^\n]+\n0+\n/\1/
	t callbackTrampoline
	# add A to the accumulator
	s/^([^\n]+)\n([^\n]+)\n([^\n]+)\n/\1+\2\n\2\n\3\n/
	x ; s/^/strictMultiply_after_addIntegers\n/ ; x
	b addIntegers
	:strictMultiply_after_addIntegers
	# decrement counter by one
	s/^([^\n]+)\n([^\n]+)\n([^\n]+)\n/\3\n\1\n\2\n/
	x ; s/^/strictMultiply_after_decrementInteger\n/ ; x
	b decrementInteger
	:strictMultiply_after_decrementInteger
	# put the counter back to 3rd line
	s/^([^\n]+)\n([^\n]+)\n([^\n]+)\n/\2\n\3\n\1\n/
	b strictMultiplyIntegers_loop
	:strictMultiplyIntegers_halt
		i strictMultiplyIntegers unexpected input!
		l ; q
# }}}

# {{{ strictDivideIntegers: divide positive integers
# Input is expected in form: A/B
:strictDivideIntegers
	t strictDivideIntegers
	# special case of division by zero
	s/^[[:digit:]]+\/0+\b/&/
	t strictDivideIntegers_halt
	# divide pieces in lines, start accumulator with 0
	s/^([[:digit:]]+)\/([[:digit:]]+)\b/0\n\1\n\2\n/
	T strictDivideIntegers_halt
	:strictDivideIntegers_loop
	t strictDivideIntegers_loop
	# stop condition is the remainder (2nd line) is zero
	s/^([^\n]+)\n0\n[^\n]+\n/\1/
	t callbackTrampoline
	# other stop is when remainder (2nd line) turned to negative
	s/^([^\n]+)\n-[[:digit:]]+\n[^\n]+\n/\1/
	t decrementInteger
	# otherwise, subtract divider (3rd line) from the remainder (2nd line)
	# and increment counter (1st line)
	s/^([^\n]+)\n([^\n]+)\n([^\n]+)\n/\2-\3\n\1\n\3\n/
	T strictDivideIntegers_halt
	x ; s/^/strictDivideIntegers_after_addIntegers\n/ ; x
	b addIntegers
	:strictDivideIntegers_after_addIntegers
	s/^([^\n]+)\n([^\n]+)\n([^\n]+)\n/\2\n\1\n\3\n/
	T strictDivideIntegers_halt
	x ; s/^/strictDivideIntegers_loop\n/ ; x
	b incrementInteger
	:strictDivideIntegers_halt
		i strictDivideIntegers_halt unexpected input!
		b errorHalt
# }}}

# {{{ strictMultiplyDivideIntegers: multiply/divide positive integers
# Input is in form: A*B or A/B
:strictMultiplyDivideIntegers
	t strictMultiplyDivideIntegers
	s/^[[:digit:]]+\*[[:digit:]]+\b/&/
	t strictMultiplyIntegers
	s/^[[:digit:]]+\/[[:digit:]]+\b/&/
	t strictDivideIntegers
	i strictMultiplyDivideIntegers unexpected input!
	b errorHalt
# }}}

# {{{ multiplyDivideIntegers: divide or multiply integers
# Assuming input in one of the following forms:
#   A*B, -A*B, A*-B, -A*-B or A/B, -A/B, A/-B, -A/-B
:multiplyDivideIntegers
	t multiplyDivideIntegers
	# chop off minuses from both integres
	s/^-([[:digit:]]+)([*\/])-([[:digit:]]+)\b/\1\2\3/
	t multiplyDivideIntegers
	s/^-([[:digit:]]+)([*\/])([[:digit:]]+)\b/\1\2\3/
	s/^([[:digit:]]+)([*\/])-([[:digit:]]+)\b/\1\2\3/
	T strictMultiplyDivideIntegers
	x ; s/^/invertInteger\n/ ; x
	b strictMultiplyDivideIntegers
# }}}

# {{{ normalizeInput: pre-process input so that all tokens are normalized
# Remove any unexpected symbols.
:normalizeInput
	t normalizeInput
	# trim unsupported chars
	s/[^[:digit:]()^./*+-]//
	t normalizeInput
	b callbackTrampoline
# }}}

# {{{ evaluateLinearExpression: evaluate expression with no parantheses
:evaluateLinearExpression
	s/([[:digit:]])(-[[:digit:]])/\1+\2/
	t evaluateLinearExpression
	s/^[^\n]+[*\/]/&/
	t evaluateLinearExpression_multDivDetected
	b evaluateLinearExpression_no_multDivDetected
	:evaluateLinearExpression_multDivDetected
		s/-?[[:digit:]]+[*\/]-?[[:digit:]]+/_&_/
		t evaluateLinearExpression_substituteMultDiv
	:evaluateLinearExpression_no_multDivDetected
	t evaluateLinearExpression_no_multDivDetected
	s/^[^\n]+[+-]/&/
	t evaluateLinearExpression_addDetected
	b evaluateLinearExpression_no_addDetected
	:evaluateLinearExpression_addDetected
		s/-?[[:digit:]]+[+-]-?[[:digit:]]+/_&_/
		t evaluateLinearExpression_substituteAdd
	:evaluateLinearExpression_no_addDetected
	t evaluateLinearExpression_no_addDetected
	b callbackTrampoline
	:evaluateLinearExpression_substituteMultDiv
		s/^(.*_)([^_]+)(_.*)$/\2\n\1\3/
		T evaluateLinearExpression_halt
		x ; s/^/evaluateLinearExpression_after_multiplyDivideIntegers\n/ ; x
		b multiplyDivideIntegers
		:evaluateLinearExpression_after_multiplyDivideIntegers
		s/^([^\n]+)\n(.*)__(.*)$/\2\1\3/
		T evaluateLinearExpression_halt
		b evaluateLinearExpression
	:evaluateLinearExpression_substituteAdd
		s/^(.*_)([^_]+)(_.*)$/\2\n\1\3/
		x ; s/^/evaluateLinearExpression_after_addIntegers\n/ ; x
		b addIntegers
		:evaluateLinearExpression_after_addIntegers
		s/^([^\n]+)\n(.*)__(.*)$/\2\1\3/
		T evaluateLinearExpression_halt
		b evaluateLinearExpression
	:evaluateLinearExpression_halt
		i evaluateLinearExpression unexpected input!
		b errorHalt
# }}}

# {{{ reduceParentheses: reduce all parantheses to their values
:reduceParentheses
	t reduceParentheses
	s/^[^\n)]*\(([^)]+)\)/\1\n&/
	T callbackTrampoline
	x ; s/^/reduceParentheses_after_evaluateLinearExpression\n/ ; x
	b evaluateLinearExpression
	:reduceParentheses_after_evaluateLinearExpression
	s/^([^\n]+)\n([^\n)]*)\([^)]+\)/\2\1/
	T reduceParentheses_halt
	b reduceParentheses
	:reduceParentheses_halt
	i reduceParentheses unexpected input!
	b errorHalt
# }}}

# {{{ evaluateExpression: evaluate whole arithmetic expression
:evaluateExpression
	x ; s/^/evaluateLinearExpression\n/ ; x
	b reduceParentheses
# }}}

# {{{ unitTestMain: trigger unit-testing
# Data in pattern and hold spaces gets destroyed. Halts after tests.
:unitTestMain
	t unitTestMain
	z ; s/^/unitTestMain_after_normalizeInput\n/ ; h
		z ; s/^/Hello World 1 + 2.3 - 9^7\n/
		b normalizeInput
		:unitTestMain_after_normalizeInput
		s/^1\+2\.3-9\^7$//
		T unitTestMain_failed_normalizeInput
	z ; s/^/unitTestMain_after_incrementDigit\n/ ; h
		z ; s/^/123 abc/
		b incrementDigit
		:unitTestMain_after_incrementDigit
		s/^223 abc$//
		T unitTestMain_failed_incrementDigit
	z ; s/^/unitTestMain_after_decrementDigit\n/ ; h
		z ; s/^/123 abc/
		b decrementDigit
		:unitTestMain_after_decrementDigit
		s/^023 abc$//
		T unitTestMain_failed_decrementDigit
	z ; s/^/unitTestMain_after_nineOutZeroes\n/ ; h
		z ; s/^/10203 10203 abc/
		b nineOutZeroes
		:unitTestMain_after_nineOutZeroes
		s/^19293 10203 abc$//
		T unitTestMain_failed_nineOutZeroes
	z ; s/^/unitTestMain_after_zeroOutNines\n/ ; h
		z ; s/^/19293 19203 abc/
		b zeroOutNines
		:unitTestMain_after_zeroOutNines
		s/^10203 19203 abc$//
		T unitTestMain_failed_zeroOutNines
	z ; s/^/unitTestMain_after_incrementInteger\n/ ; h
		z ; s/^/-19299 19203 abc/
		b incrementInteger
		:unitTestMain_after_incrementInteger
		s/^-19300 19203 abc$//
		T unitTestMain_failed_incrementInteger
	z ; s/^/unitTestMain_after_decrementInteger\n/ ; h
		z ; s/^/-19300 19203 abc/
		b decrementInteger
		:unitTestMain_after_decrementInteger
		s/^-19299 19203 abc$//
		T unitTestMain_failed_decrementInteger
	z ; s/^/unitTestMain_after_strictAddIntegers\n/ ; h
		z ; s/^/29+29 abc/
		b strictAddIntegers
		:unitTestMain_after_strictAddIntegers
		s/^58 abc$//
		T unitTestMain_failed_strictAddIntegers
	z ; s/^/unitTestMain_after_strictSubtractIntegers_positive\n/ ; h
		z ; s/^/30-19 abc/
		b strictSubtractIntegers
		:unitTestMain_after_strictSubtractIntegers_positive
		s/^11 abc$//
		T unitTestMain_failed_strictSubtractIntegers_positive
	z ; s/^/unitTestMain_after_strictSubtractIntegers_negative\n/ ; h
		z ; s/^/19-30 abc/
		b strictSubtractIntegers
		:unitTestMain_after_strictSubtractIntegers_negative
		s/^-11 abc$//
		T unitTestMain_failed_strictSubtractIntegers_negative
	z ; s/^/unitTestMain_after_addIntegers_two_negative\n/ ; h
		z ; s/^/-19-30 abc/
		b addIntegers
		:unitTestMain_after_addIntegers_two_negative
		s/^-49 abc$//
		T unitTestMain_failed_addIntegers_two_negative
	z ; s/^/unitTestMain_after_addIntegers_first_negative\n/ ; h
		z ; s/^/-19+30 abc/
		b addIntegers
		:unitTestMain_after_addIntegers_first_negative
		s/^11 abc$//
		T unitTestMain_failed_addIntegers_first_negative
	z ; s/^/unitTestMain_after_invertInteger\n/ ; h
		z ; s/^/-30 abc/
		b invertInteger
		:unitTestMain_after_invertInteger
		s/^30 abc$//
		T unitTestMain_failed_invertInteger
	z ; s/^/unitTestMain_after_addIntegers_second_negative\n/ ; h
		z ; s/^/19+-30 abc/
		b addIntegers
		:unitTestMain_after_addIntegers_second_negative
		s/^-11 abc$//
		T unitTestMain_failed_addIntegers_second_negative
	z ; s/^/unitTestMain_after_strictMultiplyIntegers\n/ ; h
		z ; s/^/12*12 abc/
		b strictMultiplyIntegers
		:unitTestMain_after_strictMultiplyIntegers
		s/^144 abc$//
		T unitTestMain_failed_strictMultiplyIntegers
	z ; s/^/unitTestMain_after_strictDivideIntegers_exactly\n/ ; h
		z ; s/^/36\/12 abc/
		b strictDivideIntegers
		:unitTestMain_after_strictDivideIntegers_exactly
		s/^3 abc$//
		T unitTestMain_failed_strictDivideIntegers_exactly
	z ; s/^/unitTestMain_after_strictDivideIntegers_remainder\n/ ; h
		z ; s/^/37\/12 abc/
		b strictDivideIntegers
		:unitTestMain_after_strictDivideIntegers_remainder
		s/^3 abc$//
		T unitTestMain_failed_strictDivideIntegers_remainder
	z ; s/^/unitTestMain_after_strictMultiplyDivideIntegers_divide\n/ ; h
		z ; s/^/37\/12 abc/
		b strictMultiplyDivideIntegers
		:unitTestMain_after_strictMultiplyDivideIntegers_divide
		s/^3 abc$//
		T unitTestMain_failed_strictMultiplyDivideIntegers_divide
	z ; s/^/unitTestMain_after_strictMultiplyDivideIntegers_multiply\n/ ; h
		z ; s/^/13*3 abc/
		b strictMultiplyDivideIntegers
		:unitTestMain_after_strictMultiplyDivideIntegers_multiply
		s/^39 abc$//
		T unitTestMain_failed_strictMultiplyDivideIntegers_multiply
	z ; s/^/unitTestMain_after_multiplyDivideIntegers_divideNegatives\n/ ; h
		z ; s/^/-37\/-12 abc/
		b multiplyDivideIntegers
		:unitTestMain_after_multiplyDivideIntegers_divideNegatives
		s/^3 abc$//
		T unitTestMain_failed_multiplyDivideIntegers_divideNegatives
	z ; s/^/unitTestMain_after_multiplyDivideIntegers_divideMixedSigns\n/ ; h
		z ; s/^/37\/-12 abc/
		b multiplyDivideIntegers
		:unitTestMain_after_multiplyDivideIntegers_divideMixedSigns
		s/^-3 abc$//
		T unitTestMain_failed_multiplyDivideIntegers_divideMixedSigns
	z ; s/^/unitTestMain_after_multiplyDivideIntegers_multiplyMixedSigns\n/ ; h
		z ; s/^/-37\*2 abc/
		b multiplyDivideIntegers
		:unitTestMain_after_multiplyDivideIntegers_multiplyMixedSigns
		s/^-74 abc$//
		T unitTestMain_failed_multiplyDivideIntegers_multiplyMixedSigns
	z ; s/^/unitTestMain_after_evaluateLinearExpression_threeAdditions\n/ ; h
		z ; s/^/-17-2+9 abc/
		b evaluateLinearExpression
		:unitTestMain_after_evaluateLinearExpression_threeAdditions
		s/^-10 abc$//
		T unitTestMain_failed_evaluateLinearExpression_threeAdditions
	z ; s/^/unitTestMain_after_evaluateLinearExpression_threeMultDiv\n/ ; h
		z ; s/^/-17*2\/3 abc/
		b evaluateLinearExpression
		:unitTestMain_after_evaluateLinearExpression_threeMultDiv
		s/^-11 abc$//
		T unitTestMain_failed_evaluateLinearExpression_threeMultDiv
	z ; s/^/unitTestMain_after_evaluateLinearExpression_addMultSubDiv\n/ ; h
		z ; s/^/5+2*3-6\/2 abc/
		b evaluateLinearExpression
		:unitTestMain_after_evaluateLinearExpression_addMultSubDiv
		s/^8 abc$//
		T unitTestMain_failed_evaluateLinearExpression_addMultSubDiv
	z ; s/^/unitTestMain_after_reduceParentheses_single\n/ ; h
		z ; s/^/5 (8+1) abc/
		b reduceParentheses
		:unitTestMain_after_reduceParentheses_single
		s/^5 9 abc$//
		T unitTestMain_failed_reduceParentheses_single
	z ; s/^/unitTestMain_after_reduceParentheses_nested\n/ ; h
		z ; s/^/5-(5+(3*2)-1) abc/
		b reduceParentheses
		:unitTestMain_after_reduceParentheses_nested
		s/^5-10 abc$//
		T unitTestMain_failed_reduceParentheses_nested
	z ; s/^/unitTestMain_after_evaluateExpression\n/ ; h
		z ; s/^/5-(5+(3*2)-1) abc/
		b evaluateExpression
		:unitTestMain_after_evaluateExpression
		s/^-5 abc$//
		T unitTestMain_failed_evaluateExpression
	i OK: Unit-tests passed!
	Q
	:unitTestMain_failed_normalizeInput
		i EE: normalizeInput self-test failed!
		b errorHalt
	:unitTestMain_failed_incrementDigit
		i EE: incrementDigit self-test failed!
		b errorHalt
	:unitTestMain_failed_decrementDigit
		i EE: decrementDigit self-test failed!
		b errorHalt
	:unitTestMain_failed_nineOutZeroes
		i EE: nineOutZeroes self-test failed!
		b errorHalt
	:unitTestMain_failed_zeroOutNines
		i EE: zeroOutNines self-test failed!
		b errorHalt
	:unitTestMain_failed_incrementInteger
		i EE: incrementInteger self-test failed!
		b errorHalt
	:unitTestMain_failed_decrementInteger
		i EE: decrementInteger self-test failed!
		b errorHalt
	:unitTestMain_failed_strictAddIntegers
		i EE: strictAddIntegers self-test failed!
		b errorHalt
	:unitTestMain_failed_strictSubtractIntegers_positive
		i EE: strictSubtractIntegers_positive self-test failed!
		b errorHalt
	:unitTestMain_failed_strictSubtractIntegers_negative
		i EE: strictSubtractIntegers_negative self-test failed!
		b errorHalt
	:unitTestMain_failed_addIntegers_two_negative
		i EE: addIntegers_two_negative self-test failed!
		b errorHalt
	:unitTestMain_failed_addIntegers_first_negative
		i EE: addIntegers_first_negative self-test failed!
		b errorHalt
	:unitTestMain_failed_addIntegers_second_negative
		i EE: addIntegers_second_negative self-test failed!
		b errorHalt
	:unitTestMain_failed_invertInteger
		i EE: invertInteger self-test failed!
		b errorHalt
	:unitTestMain_failed_strictMultiplyIntegers
		i EE: strictMultiplyIntegers self-test failed!
		b errorHalt
	:unitTestMain_failed_strictDivideIntegers_exactly
		i EE: strictDivideIntegers_exactly self-test failed!
		b errorHalt
	:unitTestMain_failed_strictDivideIntegers_remainder
		i EE: strictDivideIntegers_reminder self-test failed!
		b errorHalt
	:unitTestMain_failed_strictMultiplyDivideIntegers_divide
		i EE: strictMultiplyDivideIntegers_divide self-test failed!
		b errorHalt
	:unitTestMain_failed_strictMultiplyDivideIntegers_multiply
		i EE: strictMultiplyDivideIntegers_multiply self-test failed!
		b errorHalt
	:unitTestMain_failed_multiplyDivideIntegers_divideNegatives
		i EE: multiplyDivideIntegers_divideNegatives self-test failed!
		b errorHalt
	:unitTestMain_failed_multiplyDivideIntegers_divideMixedSigns
		i EE: multiplyDivideIntegers_divideMixedSigns self-test failed!
		b errorHalt
	:unitTestMain_failed_multiplyDivideIntegers_multiplyMixedSigns
		i EE: multiplyDivideIntegers_multiplyMixedSigns self-test failed!
		b errorHalt
	:unitTestMain_failed_evaluateLinearExpression_threeAdditions
		i EE: evaluateLinearExpression_threeAdditions self-test failed!
		b errorHalt
	:unitTestMain_failed_evaluateLinearExpression_threeMultDiv
		i EE: evaluateLinearExpression_threeMultDiv self-test failed!
		b errorHalt
	:unitTestMain_failed_evaluateLinearExpression_addMultSubDiv
		i EE: evaluateLinearExpression_addMultDivSub self-test failed!
		b errorHalt
	:unitTestMain_failed_reduceParentheses_single
		i EE: reduceParentheses_single self-test failed!
		b errorHalt
	:unitTestMain_failed_reduceParentheses_nested
		i EE: reduceParentheses_nested self-test failed!
		b errorHalt
	:unitTestMain_failed_evaluateExpression
		i EE: evaluateExpression self-test failed!
		b errorHalt
# }}}

# {{{ main: CLI entry point
:main
	t main
	/^unit-test$/ b unitTestMain
	h
	z ; s/^/main_after_normalizeInput\n/ ; x
	b normalizeInput
	:main_after_normalizeInput
	x ; s/^/main_after_evaluateExpression\n/ ; x
	b evaluateExpression
	:main_after_evaluateExpression
	p
	Q
# }}}

# vim: foldmethod=marker
