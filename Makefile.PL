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

.PHONY: pods

pods:
	otl2pod lib/Archive/Zip.otl > lib/Archive/Zip.pod
	otl2pod lib/Archive/Zip/FAQ.otl > lib/Archive/Zip/FAQ.pod
'
}

WriteMakefile(
	NAME			=> 'Archive::Zip',
	VERSION_FROM	=> 'lib/Archive/Zip.pm', # finds $VERSION
	($] < 5.005 ? () :
		(
			BINARY_LOCATION	=> $Config{'archname'} . "/\$(DISTVNAME)-PPD.tar\$(SUFFIX)",
			AUTHOR			=> 'Ned Konz (perl@bike-nomad.com)',
			ABSTRACT_FROM	=> 'lib/Archive/Zip.pod',
		)),
	PREREQ_PM		=> {
		'Compress::Zlib'    => 1.14,
		'Carp'			    => 0,
		'File::Path'	    => 0,
		'File::Find'        => 0,
		'File::Basename'	=> 0,
		'File::Spec'		=> 0,
		'File::Copy'		=> 0,
		'IO::File'			=> 0,
		'IO::Seekable'		=> 0,
		'Time::Local'		=> 0,
	},
	EXE_FILES => [ qw( crc32 ) ],
	clean			=> {
		FILES	=> 'test.log testDir/* testDir/ testin.zip testout.zip test2.zip'
	},
	dist			=> {
		COMPRESS	=> 'gzip',
		SUFFIX		=> '.gz',
		ZIP			=> 'zip',
		ZIPFLAGS	=> '-r'
	},
);

# vim: ts=4 sw=4
