#!/usr/bin/perl -w
use strict;
use Archive::Zip qw(:CONSTANTS :ERROR_CODES);
use IO::Scalar;
use IO::File;

# test reading from a scalar
my $file = IO::File->new('test.zip', 'r');
my $zipContents;
$file->read($zipContents, 20000);
$file->close();
printf "Read %d bytes\n", length($zipContents);

my $SH = IO::Scalar->new(\$zipContents);

my $zip = Archive::Zip->new();
$zip->readFromFileHandle( $SH );
my $member = $zip->addString('c' x 300, 'bunchOfCs.txt');
$member->desiredCompressionMethod(COMPRESSION_DEFLATED);
$member = $zip->addString('d' x 300, 'bunchOfDs.txt');
$member->desiredCompressionMethod(COMPRESSION_DEFLATED);

$zip->writeToFileNamed('test2.zip');
