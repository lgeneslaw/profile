#!/bin/sh
#
# bogbrd.sh  - generate a boggle board table only
#
#   arg: QUERY_STRING is a concat of an int and some letters
#
#		e.g. 2345rh
#		r => random directions
#		h => print content-type header
#		b => generate big board	(5x5)
#		n => generate normal board (4x4) -- default
#		t => create text version of table (no html wrapping)
#
#  note: uses $1 instead of QUERY_STRING if $1 is defined
#  version: 2013-04-17
#

	seed_from_file() {
		# the seed could come from a file (seed.txt)
		SEED_FROM_FILE=`sed 's/[^0-9]*//g' seed.txt` 2>/dev/null
		if [ "$?" == 0 ]; then
			# look for comments
			grep "^/" seed.txt &> /dev/null
			if [ "$?" == 1 ]; then
				SEED=$SEED_FROM_FILE
			fi
		fi
	}

	# these are default values
	SEED="$$"
	seed_from_file

	#SEED="14829"
	ROT=""
	HDR=N
	DIMS=4x4
	REG=bogreg.dat
	BIG=bogbig.dat
	DATA=$REG
	SIZE=n
	HTML=Y

	if test $# -gt 0
	then
		QUERY_STRING=$1
	fi

	if test -n "$QUERY_STRING"
	then
		QS=`echo "$QUERY_STRING" | tr -d -c '[0-9]rhnbt' `
		if echo "$QS" | grep r > /dev/null ; then
			ROT=-r	
		fi
		if echo "$QS" | grep h > /dev/null ; then
			HDR=Y
		fi
		if echo "$QS" | grep t > /dev/null ; then
			HTML=n
		fi
		if echo "$QS" | grep n > /dev/null ; then
			DATA=$REG
			SIZE=n
			SEED=$$
			#SEED=14829
		fi
		if echo "$QS" | grep b > /dev/null ; then
			DATA=$BIG
			DIMS=5x5
			SIZE=b
		fi
		QS=`echo "$QS" | tr -d -c '[0-9]'`
		if test -n "$QS"
		then
			SEED="$QS"
		fi
		seed_from_file
	fi

#
# now produce the table
#
	
	if test $HDR = Y
	then
		printf "Content-type: text/plain\r\n\r\n"
	fi

	#
	# the -d specifies dims, -h asks for header with rows and cols
	if test "$HTML" = Y
	then
		./bbgen -s $SEED -h -d $DIMS $DATA | ./bb2table $ROT
		echo "<input type='hidden' id='bbseed' value='$SEED' />"
		echo "<input type='hidden' id='bbsize' value='$SIZE' />"
		echo "<input type='hidden' id='bbsols' value='' />"
	else
		./bbgen -s $SEED -h -d $DIMS $DATA 
	fi
