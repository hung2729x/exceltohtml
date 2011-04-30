package Timer ; 

use strict ; use warnings ; 

# =============================================================================
# START OO


# the constructor 
sub new	{
	my $self = shift;
	#get the has containing all the settings
	return bless({}, $self);
} #eof new 


BEGIN { 

		# strip the remote path and keep the bare name
		$0=~m/^(.*)(\\|\/)(.*)\.([a-z]*)/; 
		my ( $MyBareName , $RunDir ) = () ; 
		$MyBareName = $3; 
		$RunDir= $1 ; 
		
		push ( @INC,$RunDir ) ; 

} #eof BEGIN

sub AUTOLOAD {
	my $self = shift ; 
	no strict 'refs'; 
    my $name = our $AUTOLOAD;
    *$AUTOLOAD = sub { 
	my $msg = "BOOM! BOOM! BOOM! \n RunTime Error !!!\nUndefined Function $name(@_)\n" ;
	logmsg($self , $msg);
    };
    goto &$AUTOLOAD;    # Restart the new routine.
}	

sub DESTROY {
	my $self = shift;
	#debug print "the DESTRUCTOR is called  \n" ; 
	return ; 
} 

# STOP OO
# =============================================================================

# =============================================================================
# START functions


#return the current time in the YYYY.MM.DD - dd:hh:ss format
sub GetHumanReadableTime {

	my $self = shift ; 
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = $self->GetTimeUnits(); 
	
	return "$year\.$mon\.$mday" . "-" . "$hour\:$min\:$sec"; 

} #eof sub GetANiceTime


sub GetTimeUnits {

my $self = shift ; 

	# Purpose: returns the time in yyyymmdd-format 
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
	#---- change 'month'- and 'year'-values to correct format ---- 
	$min = "0$min" if ($min < 10); 
	$hour = "0$hour" if ($hour < 10);
	$mon = $mon + 1;
	$mon = "0$mon" if ($mon < 10); 
	$year = $year + 1900;
	$mday = "0$mday" if ($mday < 10); 

	return ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) ; 

} #eof sub 




#return the current time in the YYYY.MM.DD - dd:hh:ss format
sub GetANiceTime {

	my $self = shift ; 
	
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = $self->GetTimeUnits(); 
	return "$year$mon$mday" . "_" . "$hour$min$sec"; 

} #eof sub GetANiceTime





# STOP functions
# =============================================================================


1;

__END__
