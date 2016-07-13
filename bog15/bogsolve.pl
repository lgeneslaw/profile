#!/usr/bin/perl
#
# bogsolve.cgi -- return the result of solving a board
#
# modperl wrapper for bogsolve.sh
# ver: 2015-03-16
#
	my $ACCT = get_page_owner();
	if ( $ACCT eq "" ){
		oops("Cannot determine game directory");
	}
	my $SITE = "/h/$ACCT/public_html/bog15";
	my $PROG = "./bogsolve.sh";

	if ( !chdir($SITE) ){
		print "Content-type: text/plain\r\n\r\n";
		print "Cannot change directory to $SITE";
		exit(0);
	}
	if ( ! -x $PROG ){
		print "Content-type: text/plain\r\n\r\n";
		print "No boggle board solver";
		exit(0);
	}
	my $ARGS = "";

	if ( !defined( $ENV{'QUERY_STRING'} ) )
	{
		$ARGS = $ARGV[0];
	}
	else {
		$ARGS = $ENV{'QUERY_STRING'};
	}
	my $result = `$PROG $ARGS`;
	print $result;

# ---------------------------------------------------------------
# this subr has to be here because we cannot know where we
# shall be run, so we use this to figure out our home dir
#
	sub get_page_owner
	{
		if ( defined( $ENV{'SCRIPT_FILENAME'} ) )
		{
			my $sfn = $ENV{'SCRIPT_FILENAME'};
			my @parts = split( /\//, $sfn );

			my $i;
			for( $i=0; $i+1 < @parts; $i++ )
			{
				if ( $parts[$i+1] eq "public_html" ){
					return $parts[$i];
				}
			}
		}

		if ( defined( $ENV{'REQUEST_URI'} ) )
		{
			my $ruri  = $ENV{'REQUEST_URI'};
			my @parts = split( /\//, $ruri );

			my $i;
			for( $i = 0; $i< @parts; $i++ )
			{
				if ( $parts[$i] =~ /^~(.*)/ ){
					return $parts[$i];
				}
				if ( $parts[$i] =~ /\.cgi$|\.pl$/ ){
					return $parts[$i-1];
				}
			}
		}

		if ( defined( $ENV{'USER' } ) ){
			return ($ENV{'USER'});
		}

		if ( defined( $ENV{'LOGNAME' } ) ){
			return ($ENV{'LOGNAME'});
		}
		return "";
	}

	sub oops
	{
		print "Content-type: text/plain\r\n\r\n";
		print "$_[0]\n";
		exit(1);
	}
