#!perl -wT

use strict;
use Test::More qw(no_plan);
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

our $error_message;

sub error {
    print @_; 
}

is (Archive::Zip::setChunkSize(), 32768, "Test initial chuck size");
Archive::Zip::setChunkSize(2048);
is (Archive::Zip::setChunkSize(), 2048, "Test setting the chunk size");
is (Archive::Zip::chunkSize(), 2048, "Test chunkSize()" );

my $zip = new Archive::Zip;
isa_ok($zip, 'Archive::Zip');
is($zip->setChunkSize, 2048, "Test setChunkSize() as an object method");

my $crc = Archive::Zip::computeCRC32( 'ghijkl' );
is($crc, 3423783853, "Test computeCRC32()");
$crc = Archive::Zip::computeCRC32( 'abcde', 1);
is($crc, 3102208469,  "Test running computeCRC32()");

my ($fh, $name) = Archive::Zip::tempFile();
isa_ok($fh, "IO::File");
ok(-f $name, "Check if tempfile exists");
my $name2;
($fh, $name2) = Archive::Zip::tempFile(".");
isa_ok($fh, "IO::File");
ok(-f $name2, "Check if tempfile exists");

Archive::Zip::setErrorHandler( \&error );
ok(mkdir('ziptest'), "Create ziptemp directory");
ok(-d 'ziptest', "Does ./ziptest exist");
ok(chmod(0400, 'ziptest'), "chmod ziptemp directory");
my $fh1;
my $name3;
eval { ($fh1, $name3) = Archive::Zip::tempFile("ziptest"); };
ok($@, "Test that tempfile() failed");
is($fh1, undef, "Test correct returns from failed tempFile call" );
is($name3, undef, "Test correct returns from failed tempFile call");
ok(chmod(0700, 'ziptest'), "chmod ziptemp directory to cleanup");
is(rmdir('ziptest'), 1, "Remove ziptemp") || diag $!; 
ok(! -d 'ziptest', "Was ziptest deleted?");

END {
    ok( unlink $name, "Remove $name");
    ok( unlink $name2, "Remove $name2");
}
