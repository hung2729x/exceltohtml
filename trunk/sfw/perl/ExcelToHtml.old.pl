package ExcelToHtml  ;

use strict ; use warnings ; use Exporter;
use Spreadsheet::ParseExcel;	use utf8 ; 
use Configurator ; 
use Logger ; 
use Encode ; 


#	anonymous hash !!!
our ( $confHolder , $objLogger , $MyBareName )= () ; 

sub main {
	
	Initialize();
	$objLogger->LogMsg	(	" START MAIN " ) ; 	
	# Action !!!
	ParseExcelGenerateHtml($confHolder);
	
	$objLogger->LogMsg	(	" STOP MAIN \n\n" ) ; 	

} #eof sub


sub Initialize {

	# strip the remote path and keep the bare name
	$0=~m/^(.*)(\\|\/)(.*)\.([a-z]*)/; 
	$MyBareName = $3; 
	my $RunDir= $1 ; 

	# create the configurator object 
	my $objConfigurator = new Configurator($RunDir , $MyBareName ); 
	# get the hash having the vars 
	$confHolder = $objConfigurator ->getConfHolder () ; 
	# pring the hash vars 
	print $objConfigurator->dumpIni();	
	$objLogger = new Logger (\$confHolder) ; 
	$objLogger->LogDebugMsg	(	"using the following settings" . $objConfigurator->dumpIni() ) ; 
	
	
} #eof sub



sub ParseExcelGenerateHtml {

my $confHolder = shift ; 
$objLogger->LogDebugMsg(" ParseExcelGenerateHtml  START " ) ; 

my $ExcelFileToParse = $confHolder->{'ExcelFileToParse'} ; 
my $OutputDir =  $confHolder->{'OutputDir'} ; 
my $strToPrint = "";

$objLogger->LogDebugMsg( " \$ExcelFileToParse : $ExcelFileToParse " ) ; 
$objLogger->LogDebugMsg( " \$MyBareName : $MyBareName " ) ; 
$objLogger->LogDebugMsg( " \$OutputDir : $OutputDir " ) ; 

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->Parse("$ExcelFileToParse");


foreach my $worksheet (@{$workbook->{Worksheet}}) {

my $workSheetName = $worksheet->{'Name'} ; 
$objLogger->LogDebugMsg( " \$workSheetName : $workSheetName" ) ; 

my $FileToPrint = ToUnixDir("$OutputDir" . '/' . "$MyBareName" . '.' . "$workSheetName" . "\.html") ; 
		$objLogger->LogDebugMsg ( "LABEL 1: \$FileToPrint is $FileToPrint " ) ; 

my $RowMin = $worksheet->{MinRow} ; 
my $RowMax= $worksheet->{MaxRow} ; 

$objLogger->LogDebugMsg( " \$RowMin : $RowMin" ) ; 
$objLogger->LogDebugMsg( " \$RowMax : $RowMax" ) ; 

    for my $row ( ($RowMin ) .. $RowMax) {
    
    my $ColMin = $worksheet->{MinCol} ; 
    my $ColMax = $worksheet->{MaxCol} ; 

		$objLogger->LogDebugMsg( " \$ColMin : $ColMin" ) ; 
		$objLogger->LogDebugMsg( " \$ColMax : $ColMax" ) ; 


				my $rowStr = "" ; 
				for my $col ( $ColMin .. $ColMax ) {
						$objLogger->LogDebugMsg ( "\$rowStr is $rowStr" ) ; 
						my $cell = $worksheet->{Cells}[$row][$col]  ; 
						my $token = '' ; 
						if ( $cell ) 
						{ $token = $cell->Value()   ; }
						
						
						
						#my $strDebug = 'Row Col   = ' . " $row" . "$col" ; 
						# $objLogger->LogDebugMsg ( $strDebug ) ; 
						#	$objLogger->LogDebugMsg ( "\$cell->encoding() is " . $cell->encoding()) ;

						
						
						
						
						$objLogger->LogDebugMsg ( "\$token is $token" ) ; 
						$rowStr .=  makeCell( $token)      ;				#The Value
						$objLogger->LogDebugMsg ( "$rowStr is $rowStr" ) ; 
						#$objLogger->LogDebugMsg ( "Unformatted = " . $cell->unformatted()) ; 

				} #eof col
			$rowStr = makeRow( $rowStr ); 
			$strToPrint .= $rowStr ; 
	 } #eof for my row

		

		$strToPrint = makeTable ( $strToPrint );
		$strToPrint = makeFile ( $strToPrint );
		$objLogger->LogDebugMsg ( "\$strToPrint is $strToPrint " ) ; 
		$objLogger->LogDebugMsg ( "LABEL 2: \$FileToPrint is $FileToPrint " ) ; 
		PrintToFile ( $FileToPrint, $strToPrint )  ; 
		$strToPrint = "" ;
		$FileToPrint = "" ;
		} #eof for my worksheet

} #eof sub


sub PrintToFile {

	my $FileToPrint = shift ; 
		$objLogger->LogDebugMsg ( "LABEL 3: \$FileToPrint is $FileToPrint " ) ; 
	
	
	my $StringToPrint = shift ; 
	#READ ALL ROWS OF A FILE TO ALIST 
	open (FILEOUTPUT, ">$FileToPrint") || 
				print "could not open the \$FileToPrint $FileToPrint $! \n"; 
	print  FILEOUTPUT $StringToPrint ; 
	close FILEOUTPUT ;

#debug $strToReturn .=  $StringToPrint; 

}
# =========================================== eof sub PrintToFile


sub makeRow 
{
	my $row = shift ; 
	my $RowStart=$confHolder->{'RowStart'} ; 
	my $RowEnd=$confHolder->{'RowEnd'} ;
	return "$RowStart" .  $row .  "$RowEnd \n"  ; 
}

sub makeCell 
{
	my $cell = shift ; 
	my $TokenStart=$confHolder->{'TokenStart'} ; 
	my $TokenEnd=$confHolder->{'TokenEnd'} ;
	return "$TokenStart"  .  "$cell" . " $TokenEnd" ; 
}

sub makeTable
{
	my $table = shift ; 
	
	my $TableStart=$confHolder->{'TableStart'} ; 
	my $TableEnd=$confHolder->{'TableEnd'} ;

	return "\n $TableStart " . $table . "$TableEnd \n" ; 

}

sub makeFile
{
	my $file = shift ; 

	my $FileStart=$confHolder->{'FileStart'} ; 
	my $FileEnd=$confHolder->{'FileEnd'} ;

	return "\n $FileStart " . $file . "$FileEnd \n" ; 
	return $file ; 
}


sub ToUnixDir {

my $dir = shift || ""; 
#replace all the \ s with / s
$dir =~ s/\\/\//g ; 
return $dir ; 

} #eof sub ToUnixDir


#Action !!!
main(); 

1 ; 

__END__

