# Test examples
# $Revision: 1.3 $
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl t/testex.t'
# vim: ts=4 sw=4 ft=perl

$^W = 1;
$| = 1;
use strict;
use Test;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use FileHandle;

BEGIN { plan tests => 6, todo => [] }

BEGIN { require 't/common.pl' }

sub runPerlCommand
{
	my $libs = join(' -I', @INC);
	my $cmd = "$^X -I$libs -w @_";
	my $output = qx($cmd);
	return wantarray ? ($?, $output) : $?;
}

use constant FILENAME => TESTDIR . 'testing.txt';
my $zip = Archive::Zip->new();
$zip->addString(TESTSTRING, FILENAME);
$zip->writeToFileNamed(INPUTZIP);

my ($status, $output);
my $fh = FileHandle->new("test.log", "w");

ok(runPerlCommand( 'examples/copy.pl', INPUTZIP, OUTPUTZIP ), 0);
ok(runPerlCommand( 'examples/extract.pl', OUTPUTZIP,  FILENAME), 0);
ok(runPerlCommand( 'examples/mfh.pl', INPUTZIP ), 0);
ok(runPerlCommand( 'examples/zip.pl', OUTPUTZIP, INPUTZIP, FILENAME ), 0);
($status, $output) = runPerlCommand( 'examples/zipinfo.pl', INPUTZIP );
ok($status, 0);
$fh->print("zipinfo output:\n");
$fh->print($output);
($status, $output) = runPerlCommand( 'examples/ziptest.pl', INPUTZIP );
ok($status, 0);
$fh->print("ziptest output:\n");
$fh->print($output);
