require 5.003_96;
use Config;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
sub MY::postamble
{ '
docs/Archive-Zip.pdf:  docs/Archive-Zip.ps
	ps2pdf $<

docs/Archive-Zip.ps:  docs/Archive-Zip.ssd
	tssd -toPS $<
'
}

WriteMakefile(
	NAME			=> 'Archive::Zip',
	VERSION_FROM	=> 'lib/Archive/Zip.pm', # finds $VERSION
	($] < 5.005 ? () :
		(
			BINARY_LOCATION	=> $Config{'archname'} . "/\$(DISTVNAME)-PPD.tar\$(SUFFIX)",
			AUTHOR			=> 'Ned Konz (perl@bike-nomad.com)',
			ABSTRACT_FROM	=> 'lib/Archive/Zip.pm',
		)),
	PREREQ_PM		=> {
		'Compress::Zlib'    => 1.06,
		'Carp'			    => 0,
		'File::Path'	    => 0,
		'File::Find'        => 0,
		'File::Basename'	=> 0,
	},
	EXE_FILES => [ qw( crc32 ) ],
	clean			=> {
		FILES	=> 'test.log testDir/* testDir/ testin.zip testout.zip'
	},
	dist			=> {
		COMPRESS	=> 'gzip',
		SUFFIX		=> '.gz',
		ZIP			=> 'zip',
		ZIPFLAGS	=> '-r'
	}
);

# vim: ts=4 sw=4
