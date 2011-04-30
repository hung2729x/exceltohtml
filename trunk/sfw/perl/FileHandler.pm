package FileHandler ; 
require Exporter;

use strict ; use warnings  ; 
use lib '.' ; 

BEGIN { 	

	my ( $MyBareName  , $LibDir , $RunDir ) = () ; 
	$RunDir = '' ; 
	$0 =~ m/^(.*)(\\|\/)(.*)\.([a-z]*)/; 
	$RunDir = $1 if defined $1 ; 
	push ( @INC , $RunDir) ; 
}




# @ISA = qw(AutoLoader Exporter);
my @EXPORT = qw(ReadFileReturnString AppendToFile);


our ( $confHolder ) = () ; 



sub ReadFileReturnString {

	my $self = shift ; 
	my $fileToRead = shift ; 

	print " readFileReturnString \$fileToRead is $fileToRead \n" ; 
	
	#todo: detect whether the file is utf8 encoded 

	#how-to slurp file
	my $string = (); 
	{
		local $/=undef;

		#all resx files are utf8 encoded !!!		
		if ( $fileToRead =~ m/resx/gi )
			{		
			open FILE, "<:utf8", "$fileToRead " or print STDERR "Couldn't open \$fileToRead $fileToRead : $!"; 
			$string = <FILE>;
			print "UTF8 STRING IS " . $string ; 
			
			}
		else 
			{ 	open FILE, "$fileToRead " or print STDERR "Couldn't open \$fileToRead $fileToRead : $!"; 
					$string = <FILE>;
			}
		
		
		close FILE;
	}
	return $string ; 
} #eof sub readFileReturnString 
# =========================================== eof sub readFileReturnString 

sub PrintToFile {

		my $self = shift ; 
		my $FileOutput = shift ; 
		my $StringToPrint = shift ; 
		#READ ALL ROWS OF A FILE TO ALIST 
		open (FILEOUTPUT, ">$FileOutput") || 
					print STDERR "could not open the \$FileOutput $FileOutput! $! \n"; 
		print  FILEOUTPUT $StringToPrint ; 
		close FILEOUTPUT ;

		#debug $strToReturn .=  $StringToPrint; 

}	#eof sub


sub AppendToFile {

		my $self = shift ; 
		my $FileOutput = shift ; 
		my $StringToPrint = shift ; 
		#READ ALL ROWS OF A FILE TO ALIST 
		open (FILEOUTPUT, ">>$FileOutput") || 
					print STDERR "could not open the \$FileOutput $FileOutput!\n"; 
		print  FILEOUTPUT $StringToPrint ; 
		close FILEOUTPUT ;

		#debug $strToReturn .=  $StringToPrint; 

}	#eof sub


sub DeleteFile {

		my $self = shift ; 
		my $FileToDelete = shift ; 
	
		#if the file exists 
		if ( -f $FileToDelete ) {
		unlink ( $FileToDelete ) 
			|| print STDERR "cannot delete \$FileToDelete $FileToDelete $! \n " ; 
	
	} #eof if
		
		#debug $strToReturn .=  $StringToPrint; 

}	#eof sub


#my @arrayTemplateFiles = () ; 
#my $arrayTemplateFiles = $objFileHandler->ReadDirGetArrayOfFiles ($InputDir); 
#@arrayTemplateFiles = @$arrayTemplateFiles ; #dereference
sub ReadDirGetArrayOfFiles 	{

	my $self = shift ; 
	my $InputDir = shift ; 
	my $FilePattern = shift ; 
	
	
	# create a list of all *.pl files in
	# the current directory
	opendir(DIR, "$InputDir") || print STDERR "cannot open \$InputDir $InputDir $! " ;
	my @files = grep(/$FilePattern$/,readdir(DIR));

	closedir(DIR);

	return \@files; 
	
	} #eof main


sub ReadFileReturnArray {

	my $self = shift ; 
	my $file = shift ; 
#READ ALL ROWS OF A FILE TO ALIST 
	 open (INPUT, "<$file") || 
	 					print STDERR  "could not open the file $file !!! $! \n\n"  ; 
	 my @ArrFile =<INPUT> ;
	 close INPUT;
	
return \@ArrFile ; 
} 

	
#changes any \ chars into / and returns the string
sub ToUnixDir {
my $self = shift ; 
my $dir = shift || print "ToUnixDir emty string passed"; 
#replace all the \ s with / s
$dir =~ s/\\/\//g ; 
return $dir ; 

} #eof sub ToUnixDir

sub MkDir {

	my $self = shift ; 
	my $dirToCreate = shift ; 
	
	# if there is !no! directory!
	if(!-d "$dirToCreate") { 
	 mkdir("$dirToCreate") || 
	 		print STDERR "Cannot create \$dirToCreate $dirToCreate $! !!!" ; 
 } #eof if


} #eof sub




#changes any \ chars into / and returns the string
sub ToWindowsDir {
my $self = shift ; 
my $dir = shift || print "ToUnixDir emty string passed"; 
#replace all the \ s with / s
$dir =~ s/\//\\/g ; 
return $dir ; 

} #eof sub ToUnixDir


# =============================================================================
# START OO


# the constructor 
# call by : $objFileHandler = new FileHandler ( \$confHolder  ) ; 
sub new	{
	my $self = shift;
	#get the has containing all the settings
	if ( @_ ) { $confHolder = ${ shift @_ } ; 	}
	

	
	
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

