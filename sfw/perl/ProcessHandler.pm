package ProcessHandler ; 

require Exporter;
use Win32 ; 
use Win32::Process ; 

use strict ; use warnings  ; 
use lib '.' ; 

BEGIN { 	

	my ( $MyBareName  , $LibDir , $RunDir ) = () ; 
	$RunDir = '' ; 
	$0 =~ m/^(.*)(\\|\/)(.*)\.([a-z]*)/; 
	$RunDir = $1 if defined $1 ; 
	push ( @INC , $RunDir) ; 	
	#debug print join ( ' ' , @INC ) ; 

} #eof sub


use Logger ; 

# @ISA = qw(AutoLoader Exporter);
my @EXPORT = qw(ForkProcOnWindows);


our  ( $confHolder , $objLogger ) = () ; 



#call me $objFileHandler->ForkProcOnWindows ( $ProcessName , $ProcessCall )
sub ForkProcOnWindows {
		
		my $self = shift ; 
		my $ProcessName= shift ; 
		# e.g. command arg1 arg2 arg3 arg4
		my $ProcessCall = shift ; 
		my ( $objProcess , $objProcessId ) = () ; 
			
		my @SplitsBySpace = split ( ' ' , $ProcessCall ) ; 
		
		#the first token is the full path to the callable process script , etc. 
		my $ProcessPath = shift @SplitsBySpace ; 
		my $Arguments = join ( ' ' , @SplitsBySpace ) ; 
		
		$objLogger-> LogDebugMsg (" Start $ProcessName with $ProcessPath " ) ; 
		
		 		
		#start process according to should we show or not console windows
		if ( $confHolder -> {'ShowProcWindow' } == 1)		{	
				Win32::Process::Create( $objProcess, "$ProcessPath", "$ProcessCall" , 0,
				CREATE_NEW_CONSOLE ,".");		
		}
		else	{	Win32::Process::Create( $objProcess, "$ProcessPath", "$ProcessCall" , 0,
				CREATE_NO_WINDOW ,".");			
		}
		$objProcessId   = $objProcess->GetProcessID() ;
		$objLogger-> LogDebugMsg (" with PID $objProcessId and Arguments $Arguments" ) ; 	
		$objLogger-> LogDebugMsg("Start $ProcessName with $ProcessCall with PID $objProcessId " ) ; 
		
		
} #eof sub




# =============================================================================
# START OO


# the constructor 
sub new	{
	my $self = shift;
	$confHolder = ${ shift @_ } ; 											
	$objLogger = shift @_  ; 											
	$objLogger->LogDebugMsg ( "ProcessHandler obj created " ) ; 
	return bless({}, $self);
} #eof new 


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

1;

__END__


#	This package is responsible for reading the ini-files
#	it is used by every other application and module in the project
#use vars qw(%variables);

