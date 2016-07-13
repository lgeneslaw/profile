#!/usr/bin/perl
#
# wrapper for bogcheck
#
#   assumes: 	This script expects to get the seed and board size
#		passed to it in QUERY_STRING, eg  1234n
#
#		And expects a list of words on stdin using post
#		copy them to a temp file
#		then run the checker 
#
#    ver: 2015-03-16
#   hist: 2013-11-24
#

	my $ACCT = get_page_owner();
	if ( $ACCT eq "" ){
		oops("Cannot determine game directory");
	}
	my $SITE = "/h/$ACCT/public_html/bog15";

	if ( !chdir( $SITE ) ){
		oops( "Cannot change directory to $SITE" );
	}

	my $qs = $ENV{'QUERY_STRING'};
	if ( $qs !~ /^\d+[a-z]$/ ){
		oops( "Query string $qs is not of correct form" );
	}

	my @words = <STDIN>;
	my $tf = `mktemp /tmp/bb.$ACCT.XXXXXX`;
	chomp $tf;
	open(F, ">$tf");
	print F @words;
	close(F);
	
	my $result = `./bogcheck.sh $qs < $tf`;
	unlink($tf);
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
