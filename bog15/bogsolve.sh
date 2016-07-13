#!/bin/sh
#
# bogsolve.cgi -- return the result of solving a board
#	
#  arg (in $1 or in QUERY_STRING) is the seed for the board and keys
#	for size (b for big, n for normal)
#  
#  outp: send as text/plain the set of HBF data
#
#  hist:
#	2013-05-01 added timeout
#

	BOARDGEN=./bogbrd.sh
	SOLVER=./bbsolver
	TIMEOUT="./timeout 30"
	# TIMEOUT="/g/15/2013f/files/bog/bin/timeout 30"

	if test $# -gt 0
	then
		QUERY_STRING=$1
	fi

	printf "Content-type: text/plain\r\n\r\n"

	if test ! -f $SOLVER
	then
		echo "No solver available"
		echo "Try later"
		exit 0
	fi

	# ---------------------------------------------
	# make sure we can execute it
	if test ! -x $SOLVER
	then
		echo "Solver is not executable"
		echo "Try later."
		exit 0
	fi

	# ---------------------------------------------
	# ok, make a board and solve it
	#
	{
		cat words.txt
		echo "."
		$BOARDGEN t$QUERY_STRING
	} | $TIMEOUT $SOLVER
