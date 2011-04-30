package Logger ; 

use lib '.' ; use strict ; use warnings ; 

BEGIN { 	

	my ( $MyBareName  , $LibDir , $RunDir ) = () ; 
	$RunDir = '' ; 
	$0 =~ m/^(.*)(\\|\/)(.*)\.([a-z]*)/; 
	$RunDir = $1 if defined $1 ; 
	push ( @INC , $RunDir) ; 	
	#debug print join ( ' ' , @INC ) ; 

} #eof sub

use Timer ; use FileHandler ; 

# the hash holding the vars 
our $confHolder = () ; 

#STOP setting vars 

# ===============================================================
# START OO


# the constructor 
sub new	{
	my $self = shift;
	#get the has containing all the settings
	$confHolder = ${ shift @_ } ; 											
	
	# if the log dir does not exist create it 
	my $LogDir = $confHolder->{'LogDir'} ; 
	if(!-d "$LogDir" ) {  
			mkdir("$LogDir") || 
			print STDERR " Cannot create the \$LogDir : $LogDir $! !!! \n" ; 
	}
	
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
	print "$self , $msg";
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

# logs a message
sub LogMsg {

	my $self = shift ; 

	# Do not print anything if the LogLevel = 0 
	if ( $confHolder->{'LogLevel'} == 0 ) {	return ; 	}

		my $objTimer= new Timer(); 
		my $HumanReadableTime = $objTimer->GetHumanReadableTime(); 

	# Do not print anything if the PrintMsgs = 0 
	if ( $confHolder->{'PrintMsgs'} == 1 || 
			 $confHolder->{'LogLevel'} == 1) 	{
		print STDOUT "\n $HumanReadableTime --- @_ \n" ; 
	}



	if ( $confHolder->{'LogLevel'} >= 4 ) 	{	

		my $LogFile = $self -> GetLogFile();
		my $objFileHandler = new FileHandler();
		
		$objFileHandler->AppendToFile( $LogFile , "$HumanReadableTime --- @_ \n" );

	} #eof if


} #eof sub


# logs an error message
sub LogErrorMsg {
	my $self = shift ; 
	my $msg = "@_" ; 
	
# Do not print anything if the PrintErrorMsgs = 0 
if ( $confHolder->{'PrintErrorMsgs'} == 0 ) 	{	return ; }
	
	
	$self->LogMsg("ERROR : $msg " ) ; 
	
} #eof sub

# logs an warning message
sub LogWarningMsg {
	my $self = shift ; 
	my $msg = "@_" ; 

# Do not print anything if the PrintWarningMsgs = 0 
if ( $confHolder->{'PrintWarningMsgs'} == 0 ) 	{	return ; }

	$self->LogMsg("WARNING : $msg " ) ; 
	
} #eof sub


# logs an warning message
sub LogInfoMsg {
	my $self = shift ; 
	my $msg = "@_" ; 
	
	# Do not print anything if the PrintInfoMsgs = 0 
	if ( $confHolder->{'PrintInfoMsgs'} == 0 ) 	{	return ; }

	
	$self->LogMsg("INFO : $msg " ) ; 
	
} #eof sub


# logs a debug message
sub LogDebugMsg {
	my $self = shift ; 
	my $msg = "@_" ; 

	
	# Do not print anything if the PrintDebugMsgs = 0 
	if ( $confHolder->{'PrintDebugMsgs'} == 0 ) 	{	return ; }
	
	$self->LogMsg("DEBUG : $msg "  ) ; 
	
} #eof sub

# logs a debug message
sub LogTraceMsg {

	my $self = shift ; 
	my $msg = "@_" ; 
	my ($package, $filename, $line, $subroutine) = caller(); 	
	
	# Do not print anything if the PrintDebugMsgs = 0 
	if ( $confHolder->{'PrintTraceMsgs'} == 0 ) 	{	return ; }
	
	$self->LogMsg("TRACE : $msg : FROM $package  $filename $line  $subroutine "  ) ; 
	
} #eof sub



sub GetLogFile {

		my $self = shift ; 
		#debug print "The log file is " . $confHolder->{ 'LogFile' } ;  
		my $LogFile = $confHolder->{ 'LogFile' } ; 
		print $confHolder->{ 'LogFile' } ; 
		return $LogFile ; 
		

}	#eof sub



# STOP functions
# =============================================================================


1;

__END__


