use strict;
use Archive::Zip qw(:ERROR_CODES);
my $zip = Archive::Zip->new();
my $blackHoleDevice = "/dev/null";	# "NUL" under Windoze

$zip->addFile($_) foreach (<*.pl>);

# Write and throw the data away.
# after members are written, the writeOffset will be set
# to the compressed size.
$zip->writeToFileNamed($blackHoleDevice);

my $totalSize = 0;
my $totalCompressedSize = 0;
foreach my $member ($zip->members())
{
	$totalSize += $member->uncompressedSize;
	$totalCompressedSize += $member->_writeOffset;
	print "Member ", $member->externalFileName,
	" size=", $member->uncompressedSize,
	", writeOffset=", $member->_writeOffset,
	", compressed=", $member->compressedSize,
	"\n";
}

print "Total Size=", $totalSize, ", total compressed=", $totalCompressedSize, "\n";

$zip->writeToFileNamed('test.zip');
