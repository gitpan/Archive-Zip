#!/bin/perl -w
# Creates a zip file, adding the given directories and files.
# Usage:
#	perl zip.pl zipfile.zip file [...]

use strict;
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);

die "usage: $0 zipfile.zip\n"
	if (scalar(@ARGV) < 2);

my $zipName = shift(@ARGV);
my $zip = Archive::Zip->new();

foreach my $memberName (@ARGV)
{
	my $member = -d $memberName
		? $zip->addDirectory( $memberName )
		: $zip->addFile( $memberName );
	warn "Can't make member $memberName\n" if ! $member;
}

my $status = $zip->writeToFileNamed($zipName);
exit $status;
