#!/bin/sh
#
# bogcheck.sh
#
#  the set of words is delivered to stdin using POST
#  therefore this script passes the stream to the validator
#  and streams the result back to stdout
#
#  note: QUERY_STRING should have ###[n|b]
#    OR: $1 should have ###[n|b}
#
#  where ### is seed, and n =>  normal 4x4 , b => big (5x5)
#
#  assumes	we are running in the directory ~user/public_html/bog15
#		AND there are world executable bbchecker and bbscorer here
#		AND there is world executable bogbrd.sh here
#
#  hist:
#	2013-11-24 added handling for modperl version
#	2013-05-01 added timeout
#

	printf "Content-type: text/plain\r\n\r\n"

	CHECK=N
	SCORE=N
	BOARDGEN=./bogbrd.sh
	CHECKER=./bbchecker
	SCORER=./bbscorer
	TIMEOUT="./timeout 30"
	# TIMEOUT="/g/15/2013f/files/bog/bin/timeout 30"
	WHERE=""
	CHKMSG=""		# error message about checker
	SCRMSG=""		# error message about scorer

	if test "$QUERY_STRING" != ""
	then
		ARGS=$QUERY_STRING
	else
		ARGS=$1
	fi

	if test -f $CHECKER ; then
		if test -x $CHECKER 
		then
			CHECK=Y
		else
			CHKMSG="bbchecker not executable"
		fi
	else
		CHKMSG="bbchecker not found"
	fi

	if test -f $SCORER ; then
		if test -x $SCORER 
		then
			SCORE=Y
		else
			SCRMSG="bbscorer not executable"
		fi
	else
		SCRMSG="cannot find bbscorer"
	fi

	# -------------------------------------------------------
	# make some temp files
	#

	TF=`mktemp /tmp/bc.XXXXXX`  || exit 1
	trap "rm -f $TF $TF.*; exit " 0 2 3 15

	#
	# read the list of words, 
	# convert spaces to newlines, convert lower to upper, remove nonalphas
	#
	# tr ' ' '\n' | tr '[a-z]' '[A-Z]' | tr -d -c '[A-Z \n]'	\
	# for now, just put each word on its own line, map lower to upper
	# and remove blank lines
	tr ' [a-z]' '\n[A-Z]' \
	|
	grep -v '^$' > $TF.user

	# -------------------------------------------------------
	#  if no checker, then tell the user

	if test "$CHECK" = "N"
	then
		echo $CHKMSG
		echo "Here are your words:"
		sort $TF.user
		exit 0
	fi

	# ------------------------------------------------------------
	#  if there is a checker, then run it on output of bogbrd.sh
	#  which will use QUERY_STRING to specify seed and size
	#  we just add 't' for text version
	#

	cat words.txt > $TF.to_check			# dict first
	echo . >> $TF.to_check				# sentinel
	$BOARDGEN t$ARGS  >> $TF.to_check		# board next
							# no sentinel

	cat $TF.to_check $TF.user | $TIMEOUT $CHECKER > $TF.checked

	# -------------------------------------------------------
	#  if no scorer, then report check output

	if test "$SCORE" = "N"
	then
		echo $SCRMSG
		echo "Here are checked results"
		echo "========================"
		cat $TF.checked
	else
		$TIMEOUT $SCORER < $TF.checked
	fi
