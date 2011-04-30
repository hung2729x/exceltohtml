package Configurator;
use lib '.' ; require Exporter;
use strict ; 
use warnings ; 

# @ISA = qw(AutoLoader Exporter);
my @EXPORT = qw(getConfHolder);

my $iniFile = () ; 

#anonymous hash !!!
my $confHolder = {

# Note NO SPACES BETWEEN THE =>
#0 - LogNothing , 1 - Print to screen , 2 - print to file , 3 - print to db , 4 - print to screen and file
LogLevel => 4 , 
,
# Whether or not to print simple messages without label
PrintMsgs => 1 
,
# Whether or not to pring INFO messages
PrintInfoMsgs => 1
,
# Whether or not to pring WARNING messages
PrintWarningMsgs => 1
,
# Whether or not to pring ERROR messages
PrintErrorMsgs => 1
,
# Whether or not to pring DEBUG messages
PrintDebugMsgs => 1
,
# Whether or not to pring TRACE messages
PrintTraceMsgs => 1
,
# The version directory of the current project 
ProjectVersionDir=> 'E:/Perl/sfw/ExcelToHtml/ExcelToHtml.1.2'
,
#The logging directory where the log files of this project version will be saved
LogDir=>'E:/Perl/sfw/ExcelToHtml/ExcelToHtml.1.2/log'
,

  };	# 1 = reboot cv agent, 2 = reboot machine, 0 = don't reboot

#ysg CONSTRUCTOR
sub new 
{
	my $self = shift;
	$iniFile = shift ; 
	
	readIni();
	$self = {} ;
	bless $self ; 
	return $self ; 
}

# This function goes through the confHolder-struct, it searches for
# strings that look like %NAMEOFPARAM%, and replaces it with the
# possible value
#BASEDIR=c:\temp\
#LOGDIR=%BASEDIR%logs\
#is changed to
#LOGDIR=c:\temp\logs\
sub doParametrisation
  {
    my $self = shift;
    my $value_l = shift;
    #debug print " before if \$value_l is $value_l \n" ; 
    
    if($value_l=~/\%([a-zA-Z]*)\%/)
    {
    		my $temp = $value_l ; 
        #debug print " AFTER 1 if \$value_l is $value_l \n" ; 
    
				my ($prt1,$value,$prt2) = ();
				
				$temp =~ m/(.*)\%([a-zA-Z]*)\%(.*)/;
				($prt1,$value,$prt2)=($1 , $2 , $3 ) ;
				# ($prt1,$value,$prt2)=/(.+?)\%([a-zA-Z]*)\%(.*)/;
				
				#debug print " AFTER 2 \$prt1 IS $prt1 ,\$value IS $value,\$prt2 IS $prt2 \n"; 
								
				if($value ne 'TMPLVL' && $value ne 'ERRORLEVEL')
				{
					$value_l=~s/\%$value\%/$confHolder->{$value}/gi;
					#debug print "REPLACED GOT \$value_l $value_l \n" ; 
				}
	
      }
      	#debug print "AFTER 3  \$value_l IS $value_l \n " ; 
    
    
        if(	$value_l=~/(.*)\%([a-zA-Z]*)\%(.*)/	)
    		{
    			#debug print "LABEL 4  \$value_l IS $value_l \n " ; 
    			doParametrisation( "I_DoNotHaveClassYet" , $value_l);
    		}
    		else 
    		{
    			#debug print "LABEL 5  \$value_l IS $value_l \n "  ;
	    		return $value_l;
    		}
    		
    		
  } #eof sub
  

#Reads the inifile, converts the %param% into param and produces the 
#confHolder structure 
sub readIni	{
	
	my $self = shift;
	my $inifile_l = $iniFile;
	if(scalar(@_)>0)
	{
		$inifile_l = shift;
	}
	open (INIFILE,$inifile_l);
	while(<INIFILE>)
	{
		if ($_ =~ /^[a-zA-Z]/) 	{
		
			my @tokens = split('=',$_);
			#the var is the left most token separated by =
			my $param_l = shift (@tokens ) ; 
			my $val_l = join ('=' , @tokens ) ; 
			
			#debug print "\$val_l is $val_l " ; 
			#deprec chomp($param_l);
			
			$param_l=trim($param_l);
			$val_l = trim($val_l);
			chomp($val_l);
			
			#debug print "\$val_l is $val_l \n" ; 
			$val_l = doParametrisation($self,$val_l);
			$confHolder->{$param_l} = $val_l;
		} #eof if
	} #eof while 
	
	close(INIFILE);
	return 1;
} #eof sub readIni

#Just dumps the ini to the screen used for debugging only
sub dumpIni	{
		
		
		my $self = shift ; 
		my $StrDump = () ; 


		readIni();
		foreach my $key (sort(keys %$confHolder))
		{
			$StrDump .=  "$key = $confHolder->{$key}\n";
		}
		
		return $StrDump ; 
} #eof sub 



sub get	{
		shift;
		my $name_l = shift;
		return $confHolder->{$name_l};
}	#eof sub

sub set 	{
		shift;
		my $name_l = shift;
		my $value_l = shift;
		$confHolder->{$name_l}=$value_l;
} #eof sub

#	Return the confHolder hash reference
sub getConfHolder 	{	

	return $confHolder ; 
} #eof sub

sub AUTOLOAD {
	no strict 'refs'; 
    my $name = our $AUTOLOAD;
    *$AUTOLOAD = sub { 
	my $msg = "BOOM! BOOM! BOOM! \n RunTime Error !!!\nI see an undefined function $name(@_)\n" ;
	my $ExcelToHtml = new QALogger(	\$confHolder	) ; #try to create the ExcelToHtml obj might fail if 
	if ($ExcelToHtml)	{$ExcelToHtml->logmsg($msg);}
	else 			{print $msg ; }
    };
    goto &$AUTOLOAD;    # Restart the new routine.
} #eof sub 	


sub DESTROY 
{
	my $self = shift;
	#debug print "the DESTRUCTOR is called  \n" ; 
	return ; 
} 

sub trim	
{
    $_[0]=~s/^\s+//;
    $_[0]=~s/\s+$//;
    return $_[0];
}


1;

__END__


#	This package is responsible for reading the ini-files
#	it is used by every other application and module in the project
#use vars qw(%variables);
# Version: 
# 1.1. added left most = in init
