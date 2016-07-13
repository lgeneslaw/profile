#!/usr/bin/perl
#
# modperl tool to get a file.  Query string is name of file
# ver: 2015-03-16
#

	my $ACCT = get_page_owner();
	if ( $ACCT eq "" ){
		oops("Cannot determine game directory");
	}
	my $SITE = "/h/$ACCT/public_html/bog15";

	if ( !chdir($SITE) ){
		oops( "Cannot change directory to $SITE" );
	}

	my $QS = $ENV{'QUERY_STRING'};
	$QS =~ s/\///g;
	my ($name,$type) = split( /\./, $QS );

	if ( $type eq "js" ){
		$type = "javascript";
	}
	elsif ( $type eq "txt" ){
		$type = "plain";
	}

	if ( -f $QS ){
		print "Content-type: text/$type\r\n\r\n";
		$F=`cat $QS`;
		print $F;
	}

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
