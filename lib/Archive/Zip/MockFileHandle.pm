# output file handle that calls a custom write routine
# $Revision: 1.1 $

use strict;
package MockFileHandle;

sub new
{
	my $class = shift || __PACKAGE__;
	$class = ref($class) || $class;
	my $self = bless( { 
		'position' => 0, 
		'size' => 0
	}, $class );
	return $self;
}

sub eof
{
	my $self = shift;
	return $self->{'position'} >= $self->{'size'};
}

# Copy given buffer to me
sub write
{
	my $self = shift;
	my $buf = \($_[0]); shift;
	my $len = shift;
	my $offset = shift || 0;

	$$buf = '' if not defined($$buf);
	my $bufLen = length($$buf);
	my $bytesWritten = ($offset + $len > $bufLen)
		? $bufLen - $offset
		: $len;
	$bytesWritten = $self->writeHook(substr($$buf, $offset, $bytesWritten));
	if ($self->{'position'} + $bytesWritten > $self->{'size'})
	{
		$self->{'size'} = $self->{'position'} + $bytesWritten
	}
	$self->{'position'} += $bytesWritten;
	return $bytesWritten;
}

# Called on each write.
# Override in subclasses.
# Return number of bytes written (0 on error).
sub writeHook
{
	my $self = shift;
	my $bytes = shift;
	return length($bytes);
}

sub binmode { 1 } 

sub close { 1 } 

sub clearerr { 1 } 

# I'm write-only!
sub read { 0 } 

sub tell { return shift->{'position'} }

# vim: ts=4 sw=4
1;
