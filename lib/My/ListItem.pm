package My::ListItem;

use strict;
use warnings;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw/value/);

1;
