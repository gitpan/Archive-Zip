#!perl -w

use strict;
use Test::More qw(no_plan);
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

Archive::Zip::setErrorHandler(sub{});
my $zip = Archive::Zip->new("testin.zip");
isa_ok($zip, "Archive::Zip");
isa_ok($zip, "Archive::Zip::Archive");

my $wont_work = Archive::Zip->new("doesntexist.zip");
is($wont_work, undef, "Test new returns undef on read failure");

is($zip->diskNumber(), 0, "Test diskNumber()");
is($zip->diskNumberWithStartOfCentralDirectory(), 0, 
    "Test diskNumberWithStartOfCentralDirectory()");
like($zip->numberOfCentralDirectoriesOnThisDisk(), qr/\d*/,
    "Test numberOfCentralDirectoriesOnThisDisk()");
like($zip->numberOfCentralDirectories(), qr/\d*/,
    "Test numberOfCentralDirectories()");
is($zip->fileName(), "testin.zip", "Test fileName()");

my @names = $zip->memberNames();
my $file;
foreach (@names) {
   $file = $_ if -f $_;
}
 
my $new_name = "extractedFile";
is($zip->extractMemberWithoutPaths($file, $new_name), AZ_OK, 
    "Test extractMemberWithoutPaths()");
ok(-f $new_name, "Was file extracted?"); 
ok(unlink $new_name, "Remove $new_name");
isnt($zip->extractMemberWithoutPaths("NoSuchFileInZip"), AZ_OK,
    "Test failed extractMemberWithoutPaths()");
isnt($zip->extractMember("NoSuchFileInZip"), AZ_OK,
    "Test failed extractMemberWithoutPaths()");

is($zip->overwrite(), AZ_OK, "Test overwrite()");
is($zip->overwriteAs("testzip2.zip"),  AZ_OK, "Test overwriteAs()");
ok(-f "testzip2.zip", "Check to see if testzip2.zip exists");
ok(unlink"testzip2.zip", "Remove testzip2.zip");

my $comment = $zip->zipfileComment("Test Comment");
is($comment, '', "Test previous comment");
is($zip->zipfileComment(), "Test Comment", "Test new comment");

my $closed = IO::File->new("t/pod.t", "r");
$closed->close();
isnt($zip->readFromFileHandle($closed, "t/pod.t"), AZ_OK,
    "Test passing closed filehandle to readFromFileHandle()");
isnt($zip->readFromFileHandle(undef, undef),  AZ_OK,
    "Test passing closed filehandle to readFromFileHandle()");
isnt($zip->writeToFileHandle($closed, "t/pod.t"), AZ_OK,
    "Test passing closed filehandle to writeToFileHandle()");
isnt($zip->writeToFileHandle(undef, undef),  AZ_OK,
    "Test passing closed filehandle to writeToFileHandle()");

#Archive::Zip::setErrorHandler(undef);
isnt($zip->addTreeMatching(), AZ_OK, 
    "Test addTreeMatching()");
isnt($zip->addTreeMatching("./t"), AZ_OK, 
    "Test addTreeMatching()");
isnt($zip->addTreeMatching("./t", "tests"), AZ_OK, 
    "Test addTreeMatching()");
is($zip->addTreeMatching("./t", "tests", qr/\.t$/), AZ_OK, 
    "Test addTreeMatching()");

is($zip->extractTree("tests", "tests"), AZ_OK,
    "Test extractTree()");
