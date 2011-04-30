use strict ; use warnings ; use Exporter;
use Spreadsheet::ParseExcel;
use File::Find ; use Cwd ; 


BEGIN { 	

	my ( $MyBareName  , $LibDir , $RunDir ) = () ; 
	$RunDir = '' ; 
	$0 =~ m/^(.*)(\\|\/)(.*)\.([a-z]*)/; 
	$RunDir = $1 if defined $1 ; 
	push ( @INC , $RunDir) ; 	
	#debug print join ( ' ' , @INC ) ; 

} 


use Configurator ; use Logger ; use FileHandler ; 


package ExcelToMSSqlInsert; 

#	anonymous hash !!!
our ( $confHolder , $objLogger , $objFileHandler , $MyBareName )= () ; 

my $VERSION = '0.6.0';

my ( $SqlInstallDir, $LogLevel , $TokenDelimiterAsciiNumber ) = () ; 
my ( $RowEnd , $FileExcelInput , $VersionDir ) = () ; 

sub  main {

	
	Initialize();
	$objLogger->LogMsg	(	" START MAIN " ) ; 	
	# Action !!!
	ParseExcelGenerateHtml($confHolder);
	
	$objLogger->LogMsg	(	" STOP MAIN \n\n" ) ; 	

} #eof sub main 



sub ParseExcelGenerateHtml {

my $confHolder = shift ; 
$objLogger->LogDebugMsg(" ParseExcelGenerateHtml  START " ) ; 

my $FileExcelInput = $confHolder->{'FileExcelInput'} ; 
my $OutputDir =  $confHolder->{'OutputDir'} ; 

$objFileHandler->MkDir( $OutputDir ) ; 

my $strToPrint = "";

$objLogger->LogDebugMsg ( " \$FileExcelInput : $FileExcelInput " ) ; 
$objLogger->LogDebugMsg ( " \$MyBareName : $MyBareName " ) ; 
$objLogger->LogDebugMsg ( " \$OutputDir : $OutputDir " ) ; 

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->Parse("$FileExcelInput");


foreach my $worksheet (@{$workbook->{Worksheet}}) {

my $workSheetName = $worksheet->{'Name'} ; 
$objLogger->LogDebugMsg ( " \$workSheetName : $workSheetName" ) ; 
my $DataBaseName=$confHolder->{'DataBaseName'} ; 
my $FileToPrint = $objFileHandler->ToUnixDir ("$OutputDir/$workSheetName" . "\.html") ; 
		$objLogger->LogDebugMsg ( "\$FileToPrint is $FileToPrint " ) ; 

my $RowMin = $worksheet->{MinRow} ; 
my $RowMax= $worksheet->{MaxRow} ; 

$objLogger->LogDebugMsg( " \$RowMin : $RowMin" ) ; 
$objLogger->LogDebugMsg( " \$RowMax : $RowMax" ) ; 

		my $rowCounter = 0 ; 
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
			$rowStr = makeRow( $rowStr , $rowCounter); 
			$strToPrint .= $rowStr ; 
			$rowCounter ++ ; 
	 } #eof for my row

		$strToPrint = makeTable ( $strToPrint );
		$strToPrint = makeFile ( $strToPrint );
		$objLogger->LogDebugMsg ( "\$strToPrint is $strToPrint " ) ; 
		$objLogger->LogDebugMsg ( "LABEL 2: \$FileToPrint is $FileToPrint " ) ; 
		$objFileHandler->PrintToFile ( $FileToPrint, $strToPrint )  ; 

		$strToPrint = "" ;
		$FileToPrint = "" ;
		} #eof for my worksheet

} #eof sub




sub makeRow 
{
	my $row = shift ; 
	my $rowCounter = shift ; 
	
	my $RowStart = $confHolder->{'RowStart'} ; 
	my $RowEnd = $confHolder->{'RowEnd'} ;
	
		if ( $rowCounter % 2 != 0 ) { 
			$RowStart = $confHolder->{'RowStartAlterNative'} ; 
	}
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


sub Initialize {

my $IniFile = "$ARGV[0]" ; 
# create the configurator object 
my $objConfigurator = new Configurator($IniFile); 
# get the hash having the vars 
$confHolder = $objConfigurator ->getConfHolder () ; 
# pring the hash vars 
print $objConfigurator->dumpIni();	
$objLogger = new Logger (\$confHolder) ; 
$objLogger->LogDebugMsg	(	"using the following settings" . $objConfigurator->dumpIni() ) ; 

$LogLevel = 																	$confHolder->{'LogLevel'} || 4 ; 
$TokenDelimiterAsciiNumber = 	chr(	$confHolder->{'TokenDelimiterAsciiNumber'}) || chr(44) ;
$RowEnd = 																	chr(	$confHolder->{'RowEnd'}) || chr(12) ;
$FileExcelInput = 													$confHolder->{'FileExcelInput'} ; 
$SqlInstallDir = 														$confHolder->{'SqlInstallDir'} ; 

$objLogger->LogDebugMsg	 ( "\$FileExcelInput is $FileExcelInput" ) ; 
$objLogger->LogDebugMsg	(	"using the following settings" . $objConfigurator->dumpIni	() ) ; 

$objFileHandler = new FileHandler ( \$confHolder ) ; 

} #eof sub




# =========================================== eof sub trim 
# Action !!!
main(); 

1 ; 

__END__

=head1 NAME

ExcelToSqlInsert - 

=head1 DESCRIPTION

todo:add desc 

=head1 README

for how-to use this script check the ReadMe.txt 

=head1 PREREQUISITES

SpreadSheet::ParseExcel
Exporter
FileHandler
The sql Server 2008 client

=head1 COREQUISITES


=pod OSNAMES

any ( Windows 7 only tested ) 

=pod SCRIPT CATEGORIES

configurations 
=cut
