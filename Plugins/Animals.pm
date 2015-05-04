package Animals;

use strict;
use warnings;

use Module::Pluggable require => 1;

sub new {
	my $class = shift;
	my $self = {};
	return bless $self, $class;
}

sub sound {
	my $self = shift;
	for my $plugin( $self->plugins ) {
		print "Plugin: $plugin\n";
		print $plugin->sound();
		next if ! $plugin->can('sound');
	}
}

1;
